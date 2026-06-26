import Foundation
import UserNotifications

@MainActor
final class GoalNotificationService {
    static let shared = GoalNotificationService()
    private init() {}

    private var canUseNotifications: Bool {
        Bundle.main.bundleIdentifier != nil
    }

    private static let kLastNotified  = "UpworkBuddyGoalLastNotified"
    private static let kLastResetSeen = "UpworkBuddyGoalLastResetSeen"
    private static let kLastProgress  = "UpworkBuddyGoalLastProgress"

    func requestAuthorizationIfNeeded() async {
        guard canUseNotifications else { return }
        let center = UNUserNotificationCenter.current()
        let settings = await center.notificationSettings()
        guard settings.authorizationStatus == .notDetermined else { return }
        do {
            _ = try await center.requestAuthorization(options: [.alert, .sound])
        } catch {
            Log.goals.error("Notification auth failed: \(error.localizedDescription, privacy: .public)")
        }
    }

    func cancelPending() {
        guard canUseNotifications else { return }
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }

    /// Inspect each (metric, period) pair on the active store. Sends:
    ///   • progress notifications when the user crosses each enabled threshold
    ///     (e.g., 75/90/95%) for the first time in the current bucket
    ///   • a goal-hit notification + confetti trigger at 100%
    ///   • an optional "session reset" notification when a new bucket begins
    func evaluate(store: AppStore) async {
        guard store.goalsEnabled else { return }

        let notificationsAllowed: Bool = await {
            guard canUseNotifications else { return false }
            let settings = await UNUserNotificationCenter.current().notificationSettings()
            return settings.authorizationStatus == .authorized
                || settings.authorizationStatus == .provisional
        }()

        var lastMap = loadMap(Self.kLastNotified)
        var resetMap = loadMap(Self.kLastResetSeen)
        var progressMap = loadMap(Self.kLastProgress)
        let format = CurrencyFormat(code: store.currency, masked: false)

        let pairs: [(Period, EarningsSnapshot)] = {
            if store.selectedPeriod == .today {
                return [(.today, store.todaySnapshot)]
            } else {
                return [(.today, store.todaySnapshot), (store.selectedPeriod, store.snapshot)]
            }
        }()

        for (period, snap) in pairs {
            let bucket = bucketKey(for: period, on: Date())

            // Session reset detection (only when at least one target is set for this period)
            let hasAnyTarget = store.goalTarget(for: .hours, period: period) > 0
                || store.goalTarget(for: .earnings, period: period) > 0
            if hasAnyTarget {
                let resetKey = "reset-\(period.rawValue)"
                let prior = resetMap[resetKey]
                if prior == nil {
                    // First sighting — record without firing.
                    resetMap[resetKey] = bucket
                } else if prior != bucket {
                    if notificationsAllowed && store.progressNotificationsEnabled && store.notifyOnSessionReset {
                        let body = "New \(period.label.lowercased()) — your goal resets to 0%."
                        await send(
                            title: "Fresh start",
                            body: body,
                            identifier: "\(resetKey)-\(bucket)",
                            withSound: store.notificationSoundEnabled
                        )
                    }
                    resetMap[resetKey] = bucket
                }
            }

            for metric in [MenuBarMetric.hours, .earnings] {
                let target = store.goalTarget(for: metric, period: period)
                guard target > 0 else { continue }
                let current = (metric == .hours) ? snap.totalHours : snap.totalEarnings
                let pct = max(0, Int((current / target) * 100))
                let mapKey = "\(metric.rawValue)-\(period.rawValue)"
                let progressKey = "seen-\(mapKey)"
                let priorPct = Self.storedProgress(progressMap[progressKey], bucket: bucket)
                if pct == 0 {
                    progressMap[progressKey] = Self.progressValue(bucket: bucket, pct: pct)
                    continue
                }

                let actualText = (metric == .hours) ? current.asHours() : format.string(current)
                let targetText = (metric == .hours) ? target.asHours() : format.string(target)
                let metricLabel = (metric == .hours) ? "Hours" : "Earnings"

                // Progress thresholds (sub-100). Always-evaluated 100% threshold is below.
                if notificationsAllowed && store.progressNotificationsEnabled {
                    for threshold in store.enabledThresholds.sorted()
                    where threshold < 100 && Self.crossedThreshold(previous: priorPct, current: pct, threshold: threshold) {
                        let key = "prog-\(metric.rawValue)-\(period.rawValue)-\(threshold)"
                        if lastMap[key] == bucket { continue }
                        let remaining = max(0, 100 - threshold)
                        let body = "\(period.label) \(metricLabel.lowercased()) at \(threshold)% — \(actualText) of \(targetText). \(remaining)% to go."
                        await send(
                            title: "\(threshold)% there",
                            body: body,
                            identifier: "\(key)-\(bucket)",
                            withSound: store.notificationSoundEnabled
                        )
                        lastMap[key] = bucket
                    }
                }

                // Goal hit (100%): fires regardless of progressNotificationsEnabled, since
                // the user explicitly opted in via goalsEnabled. Also drives confetti.
                if Self.crossedThreshold(previous: priorPct, current: pct, threshold: 100, includeFirstObservation: true) {
                    if lastMap[mapKey] != bucket {
                        if notificationsAllowed {
                            let body = "\(period.label) target reached — \(actualText) of \(targetText)."
                            await send(
                                title: "\(metricLabel) goal hit",
                                body: body,
                                identifier: "\(mapKey)-\(bucket)",
                                withSound: store.notificationSoundEnabled
                            )
                        }
                        lastMap[mapKey] = bucket
                        Log.goals.info("Goal hit \(mapKey, privacy: .public) bucket \(bucket, privacy: .public)")
                        if store.goalCelebrationEnabled {
                            store.celebrate()
                        }
                    }
                }

                progressMap[progressKey] = Self.progressValue(bucket: bucket, pct: pct)
            }
        }

        saveMap(lastMap, key: Self.kLastNotified)
        saveMap(resetMap, key: Self.kLastResetSeen)
        saveMap(progressMap, key: Self.kLastProgress)
    }

    // MARK: - Private

    private func send(title: String, body: String, identifier: String, withSound: Bool) async {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        if withSound { content.sound = .default }
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: nil)
        do {
            try await UNUserNotificationCenter.current().add(request)
        } catch {
            Log.goals.error("Notification add failed: \(error.localizedDescription, privacy: .public)")
        }
    }

    private func loadMap(_ key: String) -> [String: String] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let map = try? JSONDecoder().decode([String: String].self, from: data) else {
            return [:]
        }
        return map
    }

    private func saveMap(_ map: [String: String], key: String) {
        guard let data = try? JSONEncoder().encode(map) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }

    static func crossedThreshold(previous: Int?, current: Int, threshold: Int, includeFirstObservation: Bool = false) -> Bool {
        guard let previous else { return includeFirstObservation && current >= threshold }
        return previous < threshold && current >= threshold
    }

    private static func progressValue(bucket: String, pct: Int) -> String {
        "\(bucket):\(pct)"
    }

    private static func storedProgress(_ raw: String?, bucket: String) -> Int? {
        guard let raw else { return nil }
        let parts = raw.split(separator: ":", maxSplits: 1)
        guard parts.count == 2, String(parts[0]) == bucket else { return nil }
        return Int(parts[1])
    }

    private func bucketKey(for period: Period, on date: Date) -> String {
        Self.bucketKey(for: period, on: date, timeZone: .current)
    }

    /// Period-aligned identifier used to dedupe notifications within a single
    /// day/week/month/year. Exposed for testing — `timeZone` lets tests pin
    /// behavior independently of the host machine's zone.
    static func bucketKey(for period: Period, on date: Date, timeZone: TimeZone = .current) -> String {
        var cal = Calendar(identifier: .iso8601)
        cal.timeZone = timeZone
        let f = DateFormatter()
        f.calendar = cal
        f.timeZone = timeZone
        f.locale = Locale(identifier: "en_US_POSIX")
        switch period {
        case .today:
            f.dateFormat = "yyyy-MM-dd"
        case .week:
            f.dateFormat = "YYYY-'W'ww"
        case .month:
            f.dateFormat = "yyyy-MM"
        case .year:
            f.dateFormat = "yyyy"
        }
        return f.string(from: date)
    }
}
