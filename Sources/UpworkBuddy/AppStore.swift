import Foundation
import Observation

enum MenuBarMetric: String, CaseIterable, Sendable {
    case hours
    case earnings
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
    var sparkline: [DailyPoint] = []

    // MARK: - Loading
    private var loadingCount: Int = 0
    var isLoading: Bool { loadingCount > 0 }

    // MARK: - Settings (persisted via didSet -> UserDefaults)
    private static let kRefreshSeconds = "UpworkBuddyRefreshSeconds"
    private static let kCurrencyCode   = "UpworkBuddyCurrency"
    private static let kHideSensitive  = "UpworkBuddyHideSensitive"
    private static let kMenuBarMetric  = "UpworkBuddyMenuBarMetric"
    private static let kDashboardMetric = "UpworkBuddyDashboardMetric"

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
            async let sparkResult = api.fetchCombinedEarnings(range: sparkRange, aceId: aceId)
            async let todayResult: (EarningsSnapshot, [DailyPoint])? = (selectedPeriod == .today)
                ? nil
                : api.fetchCombinedEarnings(range: todayRange, aceId: aceId)

            let (periodSnap, _) = try await periodResult
            let (_, sparkDaily) = try await sparkResult
            let todayPair = try await todayResult

            snapshot = periodSnap
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
