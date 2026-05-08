import Foundation
import Observation

enum MenuBarMetric: String, CaseIterable, Sendable {
    case hours
    case earnings
}

/// Wrapper that lets us encode an `Optional<Shortcut>` inside a JSON dictionary.
struct ShortcutCodable: Codable, Sendable {
    let shortcut: Shortcut?
}

enum MenuBarIconStyle: String, CaseIterable, Sendable {
    case iconValue   // SF symbol + value (default)
    case iconOnly    // symbol only
    case valueOnly   // value only

    var label: String {
        switch self {
        case .iconValue: return "Icon + value"
        case .iconOnly:  return "Icon only"
        case .valueOnly: return "Value only"
        }
    }
}

@MainActor
@Observable
final class AppStore {
    // MARK: - Auth state
    var isAuthenticated: Bool = false
    var lastError: String?

    // MARK: - Period + data
    var selectedPeriod: Period = .today
    var snapshot: EarningsSnapshot = .empty
    var todaySnapshot: EarningsSnapshot = .empty
    var previousSnapshot: EarningsSnapshot = .empty
    var sparkline: [DailyPoint] = []

    // MARK: - Loading
    private var loadingCount: Int = 0
    var isLoading: Bool { loadingCount > 0 }

    // MARK: - Settings (persisted via didSet -> UserDefaults)
    private static let kRefreshSeconds  = "UpworkBuddyRefreshSeconds"
    private static let kCurrencyCode    = "UpworkBuddyCurrency"
    private static let kHideSensitive   = "UpworkBuddyHideSensitive"
    private static let kMenuBarMetric   = "UpworkBuddyMenuBarMetric"
    private static let kDashboardMetric = "UpworkBuddyDashboardMetric"
    private static let kLaunchAtLogin   = "UpworkBuddyLaunchAtLogin"
    private static let kGoalHoursDaily  = "UpworkBuddyGoalHoursDaily"
    private static let kGoalHoursWeekly = "UpworkBuddyGoalHoursWeekly"
    private static let kMenuBarIconStyle = "UpworkBuddyMenuBarIconStyle"
    private static let kShortcuts        = "UpworkBuddyShortcuts"

    var refreshIntervalSeconds: Int {
        didSet { UserDefaults.standard.set(refreshIntervalSeconds, forKey: Self.kRefreshSeconds) }
    }

    var currency: String {
        didSet { UserDefaults.standard.set(currency, forKey: Self.kCurrencyCode) }
    }

    var hideSensitive: Bool {
        didSet { UserDefaults.standard.set(hideSensitive, forKey: Self.kHideSensitive) }
    }

    var menuBarMetric: MenuBarMetric {
        didSet { UserDefaults.standard.set(menuBarMetric.rawValue, forKey: Self.kMenuBarMetric) }
    }

    var dashboardMetric: MenuBarMetric {
        didSet { UserDefaults.standard.set(dashboardMetric.rawValue, forKey: Self.kDashboardMetric) }
    }

    var launchAtLogin: Bool {
        didSet {
            UserDefaults.standard.set(launchAtLogin, forKey: Self.kLaunchAtLogin)
            LoginItemManager.apply(enabled: launchAtLogin)
        }
    }

    var goalHoursDaily: Double {
        didSet { UserDefaults.standard.set(goalHoursDaily, forKey: Self.kGoalHoursDaily) }
    }

    var goalHoursWeekly: Double {
        didSet { UserDefaults.standard.set(goalHoursWeekly, forKey: Self.kGoalHoursWeekly) }
    }

    var menuBarIconStyle: MenuBarIconStyle {
        didSet { UserDefaults.standard.set(menuBarIconStyle.rawValue, forKey: Self.kMenuBarIconStyle) }
    }

    /// Per-action user-overridable shortcuts. `nil` value means "unbound".
    var shortcuts: [ShortcutAction: Shortcut?] {
        didSet { persistShortcuts() }
    }

    private let api = UpworkAPI()
    private var refreshTask: Task<Void, Never>?
    private var aceId: String?

    init() {
        let defaults = UserDefaults.standard
        let storedRefresh = defaults.integer(forKey: Self.kRefreshSeconds)
        self.refreshIntervalSeconds = storedRefresh > 0 ? storedRefresh : 300
        self.currency = defaults.string(forKey: Self.kCurrencyCode) ?? "USD"
        self.hideSensitive = defaults.bool(forKey: Self.kHideSensitive)
        let storedMetric = defaults.string(forKey: Self.kMenuBarMetric).flatMap(MenuBarMetric.init(rawValue:))
        self.menuBarMetric = storedMetric ?? .hours
        let storedDash = defaults.string(forKey: Self.kDashboardMetric).flatMap(MenuBarMetric.init(rawValue:))
        self.dashboardMetric = storedDash ?? .earnings

        // Reconcile launchAtLogin with actual SMAppService state — user may
        // have toggled it from System Settings → General → Login Items.
        let storedLaunch = defaults.bool(forKey: Self.kLaunchAtLogin)
        let actualLaunch = LoginItemManager.isEnabled
        self.launchAtLogin = actualLaunch || storedLaunch
        if storedLaunch != actualLaunch {
            UserDefaults.standard.set(actualLaunch, forKey: Self.kLaunchAtLogin)
        }

        let storedDaily = defaults.double(forKey: Self.kGoalHoursDaily)
        self.goalHoursDaily = storedDaily > 0 ? storedDaily : 0   // 0 hides ring
        let storedWeekly = defaults.double(forKey: Self.kGoalHoursWeekly)
        self.goalHoursWeekly = storedWeekly > 0 ? storedWeekly : 0

        let storedIcon = defaults.string(forKey: Self.kMenuBarIconStyle).flatMap(MenuBarIconStyle.init(rawValue:))
        self.menuBarIconStyle = storedIcon ?? .iconValue

        // Shortcuts: load JSON, fall back to per-action defaults.
        var loaded: [ShortcutAction: Shortcut?] = [:]
        if let data = defaults.data(forKey: Self.kShortcuts),
           let decoded = try? JSONDecoder().decode([String: ShortcutCodable].self, from: data) {
            for (rawKey, value) in decoded {
                guard let action = ShortcutAction(rawValue: rawKey) else { continue }
                loaded[action] = value.shortcut
            }
        }
        for action in ShortcutAction.allCases where loaded[action] == nil {
            loaded[action] = action.defaultShortcut
        }
        self.shortcuts = loaded
    }

    private func persistShortcuts() {
        var encodable: [String: ShortcutCodable] = [:]
        for (action, shortcut) in shortcuts {
            encodable[action.rawValue] = ShortcutCodable(shortcut: shortcut)
        }
        if let data = try? JSONEncoder().encode(encodable) {
            UserDefaults.standard.set(data, forKey: Self.kShortcuts)
        }
    }

    func setShortcut(_ shortcut: Shortcut?, for action: ShortcutAction) {
        shortcuts[action] = shortcut
    }

    func resetShortcut(for action: ShortcutAction) {
        shortcuts[action] = action.defaultShortcut
    }

    /// Re-read the system login-item state and update the toggle. Call from
    /// `applicationDidBecomeActive` so the UI reflects out-of-app changes.
    func reconcileLaunchAtLogin() {
        let actual = LoginItemManager.isEnabled
        if actual != launchAtLogin { launchAtLogin = actual }
    }

    var goalHoursTarget: Double {
        switch selectedPeriod {
        case .today:       return goalHoursDaily
        case .week:        return goalHoursWeekly
        case .month, .year: return 0
        }
    }

    // MARK: - Bootstrap

    func bootstrap() async {
        if KeychainStore.read(.refresh) != nil {
            isAuthenticated = true
            await resolveAceAndRefresh(force: true)
        } else {
            isAuthenticated = false
        }
    }

    func resolveAceAndRefresh(force: Bool) async {
        do {
            aceId = try await api.fetchAccountingEntityId()
            await refresh(force: force)
        } catch {
            handle(error)
        }
    }

    // MARK: - Period

    func switchTo(period: Period) {
        guard period != selectedPeriod else { return }
        selectedPeriod = period
        Task { await refresh(force: false) }
    }

    // MARK: - Refresh

    func refresh(force: Bool) async {
        guard isAuthenticated else { return }
        guard let ace = aceId else {
            do {
                aceId = try await api.fetchAccountingEntityId()
            } catch {
                handle(error)
                return
            }
            await refresh(force: force)
            return
        }
        refreshTask?.cancel()
        let task = Task { @MainActor in
            await self.performRefresh(aceId: ace, force: force)
        }
        refreshTask = task
        await task.value
    }

    private func performRefresh(aceId: String, force: Bool) async {
        let periodRange = DateRanges.range(for: selectedPeriod)
        let prevRange = DateRanges.previousRange(for: selectedPeriod)
        let sparkRange = DateRanges.sparklineRange(days: selectedPeriod.sparklineDays)
        let todayRange = DateRanges.range(for: .today)

        let key = ReportCache.Key(
            tenantId: "",
            rangeStart: periodRange.startString,
            rangeEnd: periodRange.endString
        )

        if !force, let cached = await ReportCache.shared.get(key) {
            snapshot = cached.snapshot
            sparkline = cached.daily.suffix(selectedPeriod.sparklineDays)
        }

        loadingCount += 1
        defer { loadingCount -= 1 }

        do {
            async let periodResult = api.fetchCombinedEarnings(range: periodRange, aceId: aceId)
            async let prevResult = api.fetchCombinedEarnings(range: prevRange, aceId: aceId)
            async let sparkResult = api.fetchCombinedEarnings(range: sparkRange, aceId: aceId)
            async let todayResult: (EarningsSnapshot, [DailyPoint])? = (selectedPeriod == .today)
                ? nil
                : api.fetchCombinedEarnings(range: todayRange, aceId: aceId)

            let (periodSnap, _) = try await periodResult
            let (prevSnap, _) = try await prevResult
            let (_, sparkDaily) = try await sparkResult
            let todayPair = try await todayResult

            snapshot = periodSnap
            previousSnapshot = prevSnap
            sparkline = sparkDaily
            await ReportCache.shared.set(key, snapshot: periodSnap, daily: sparkDaily)

            if selectedPeriod == .today {
                todaySnapshot = periodSnap
            } else if let pair = todayPair {
                todaySnapshot = pair.0
            }

            lastError = nil
        } catch is CancellationError {
            // Period changed mid-flight; ignore.
        } catch {
            handle(error)
        }
    }

    // MARK: - Auth

    func startLogin() {
        Task {
            do {
                try await OAuthClient.shared.startAuthorization()
            } catch {
                handle(error)
            }
        }
    }

    func completeLogin() async {
        isAuthenticated = true
        lastError = nil
        await resolveAceAndRefresh(force: true)
    }

    func logout() async {
        await OAuthClient.shared.logout()
        await ReportCache.shared.clear()
        aceId = nil
        snapshot = .empty
        todaySnapshot = .empty
        previousSnapshot = .empty
        sparkline = []
        isAuthenticated = false
    }

    // MARK: - Errors

    private func handle(_ error: Error) {
        Log.app.error("AppStore error: \(error.localizedDescription, privacy: .public)")
        if case UpworkError.unauthorized = error {
            Task { await logout() }
        }
        lastError = error.localizedDescription
    }
}
