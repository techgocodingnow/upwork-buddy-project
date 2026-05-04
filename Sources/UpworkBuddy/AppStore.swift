import Foundation
import Observation

@MainActor
@Observable
final class AppStore {
    // MARK: - Auth state
    var isAuthenticated: Bool = false
    var lastError: String?

    // MARK: - Tenant
    var tenants: [Tenant] = []
    var selectedTenantId: String?

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
    private static let kTenantId       = "UpworkBuddyTenantId"

    var refreshIntervalSeconds: Int {
        didSet { UserDefaults.standard.set(refreshIntervalSeconds, forKey: Self.kRefreshSeconds) }
    }

    var currency: String {
        didSet { UserDefaults.standard.set(currency, forKey: Self.kCurrencyCode) }
    }

    private let api = UpworkAPI()
    private var refreshTask: Task<Void, Never>?

    init() {
        let defaults = UserDefaults.standard
        let storedRefresh = defaults.integer(forKey: Self.kRefreshSeconds)
        self.refreshIntervalSeconds = storedRefresh > 0 ? storedRefresh : 300
        self.currency = defaults.string(forKey: Self.kCurrencyCode) ?? "USD"
    }

    // MARK: - Bootstrap

    func bootstrap() async {
        if KeychainStore.read(.refresh) != nil {
            isAuthenticated = true
            await loadTenantsAndRefresh(force: true)
        } else {
            isAuthenticated = false
        }
    }

    func loadTenantsAndRefresh(force: Bool) async {
        do {
            let fetched = try await api.fetchTenants()
            tenants = fetched
            let preferred = UserDefaults.standard.string(forKey: Self.kTenantId)
            let chosen = fetched.first(where: { $0.id == preferred }) ?? fetched.first
            selectedTenantId = chosen?.id
            await GraphQLClient.shared.setTenantId(chosen?.id)
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
        guard isAuthenticated, let tenant = selectedTenantId else { return }
        refreshTask?.cancel()
        let task = Task { @MainActor in
            await self.performRefresh(tenant: tenant, force: force)
        }
        refreshTask = task
        await task.value
    }

    private func performRefresh(tenant: String, force: Bool) async {
        let periodRange = DateRanges.range(for: selectedPeriod)
        let sparkRange = DateRanges.sparklineRange(days: selectedPeriod.sparklineDays)
        let todayRange = DateRanges.range(for: .today)

        let key = ReportCache.Key(
            tenantId: tenant,
            rangeStart: periodRange.startString,
            rangeEnd: periodRange.endString
        )

        // Cache hit — surface immediately, skip network unless forced.
        if !force, let cached = await ReportCache.shared.get(key) {
            snapshot = cached.snapshot
            sparkline = cached.daily.suffix(selectedPeriod.sparklineDays)
        }

        loadingCount += 1
        defer { loadingCount -= 1 }

        do {
            async let periodResult = api.fetchTimeReport(range: periodRange, organizationId: tenant)
            async let sparkResult = api.fetchTimeReport(range: sparkRange, organizationId: tenant)
            async let todayResult: (EarningsSnapshot, [DailyPoint])? = (selectedPeriod == .today)
                ? nil
                : api.fetchTimeReport(range: todayRange, organizationId: tenant)

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
        await loadTenantsAndRefresh(force: true)
    }

    func logout() async {
        await OAuthClient.shared.logout()
        await ReportCache.shared.clear()
        await GraphQLClient.shared.setTenantId(nil)
        tenants = []
        selectedTenantId = nil
        snapshot = .empty
        todaySnapshot = .empty
        sparkline = []
        isAuthenticated = false
    }

    // MARK: - Tenant selection

    func selectTenant(_ id: String) {
        selectedTenantId = id
        UserDefaults.standard.set(id, forKey: Self.kTenantId)
        Task {
            await GraphQLClient.shared.setTenantId(id)
            await refresh(force: true)
        }
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
