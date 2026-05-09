import Foundation
import UserNotifications

@MainActor
final class GoalNotificationService {
    static let shared = GoalNotificationService()
    private init() {}

    private static let kLastNotified = "UpworkBuddyGoalLastNotified"

    func requestAuthorizationIfNeeded() async {
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
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }

    /// Inspect each (metric, period) pair on the active store. If the user has crossed
    /// a target for the first time in the current bucket, send a local notification.
    func evaluate(store: AppStore) async {
        guard store.goalsEnabled else { return }

        let center = UNUserNotificationCenter.current()
        let settings = await center.notificationSettings()
        let authorized = (settings.authorizationStatus == .authorized || settings.authorizationStatus == .provisional)
        guard authorized else { return }

        var lastMap = loadLastNotified()
        let format = CurrencyFormat(code: store.currency, masked: false)

        // Evaluate today (using todaySnapshot — guaranteed fresh post-refresh)
        // and the currently selected period (using snapshot).
        let pairs: [(Period, EarningsSnapshot)] = {
            if store.selectedPeriod == .today {
                return [(.today, store.todaySnapshot)]
            } else {
                return [(.today, store.todaySnapshot), (store.selectedPeriod, store.snapshot)]
            }
        }()

        for (period, snap) in pairs {
            for metric in [MenuBarMetric.hours, .earnings] {
                let target = store.goalTarget(for: metric, period: period)
                guard target > 0 else { continue }
                let current = (metric == .hours) ? snap.totalHours : snap.totalEarnings
                guard current >= target else { continue }

                let bucket = bucketKey(for: period, on: Date())
                let mapKey = "\(metric.rawValue)-\(period.rawValue)"
                if lastMap[mapKey] == bucket { continue }

                let title = (metric == .hours ? "Hours goal hit" : "Earnings goal hit")
                let actualText = (metric == .hours) ? current.asHours() : format.string(current)
                let targetText = (metric == .hours) ? target.asHours() : format.string(target)
                let body = "\(period.label) target reached — \(actualText) of \(targetText)."

                await send(title: title, body: body, identifier: "\(mapKey)-\(bucket)")
                lastMap[mapKey] = bucket
                Log.goals.info("Goal hit \(mapKey, privacy: .public) bucket \(bucket, privacy: .public)")
            }
        }

        saveLastNotified(lastMap)
    }

    // MARK: - Private

    private func send(title: String, body: String, identifier: String) async {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: nil)
        do {
            try await UNUserNotificationCenter.current().add(request)
        } catch {
            Log.goals.error("Notification add failed: \(error.localizedDescription, privacy: .public)")
        }
    }

    private func loadLastNotified() -> [String: String] {
        guard let data = UserDefaults.standard.data(forKey: Self.kLastNotified),
              let map = try? JSONDecoder().decode([String: String].self, from: data) else {
            return [:]
        }
        return map
    }

    private func saveLastNotified(_ map: [String: String]) {
        guard let data = try? JSONEncoder().encode(map) else { return }
        UserDefaults.standard.set(data, forKey: Self.kLastNotified)
    }

    private func bucketKey(for period: Period, on date: Date) -> String {
        var cal = Calendar(identifier: .iso8601)
        cal.timeZone = .current
        let f = DateFormatter()
        f.calendar = cal
        f.timeZone = .current
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
