import SwiftUI

struct TodayPulse: View {
    let points: [DailyPoint]
    let snapshot: EarningsSnapshot
    let currency: String
    var masked: Bool = false

    var body: some View {
        let format = CurrencyFormat(code: currency, masked: masked)
        let cal = Calendar.current
        let todayStart = cal.startOfDay(for: Date())

        let weekPoints: [DailyPoint] = {
            guard let weekStart = cal.date(byAdding: .day, value: -6, to: todayStart) else { return [] }
            return points.filter { $0.date >= weekStart && $0.date <= todayStart }
        }()

        let weekTotal = weekPoints.reduce(0) { $0 + $1.earnings }
        let activeDays = weekPoints.filter { $0.hours > 0 || $0.earnings > 0 }.count
        let dailyAvg = activeDays > 0 ? weekTotal / Double(activeDays) : 0

        let streak = currentStreak(points: points, todayStart: todayStart, calendar: cal)

        let lastActivity = points
            .filter { $0.hours > 0 || $0.earnings > 0 }
            .max(by: { $0.date < $1.date })

        VStack(alignment: .leading, spacing: 10) {
            SectionDotLabel(title: L10n.t("Today's pulse"))

            HStack(spacing: 8) {
                pulseCard(
                    label: L10n.t("Daily avg"),
                    primary: format.compact(dailyAvg),
                    secondary: L10n.t("%d active days", activeDays),
                    tint: Theme.textPrimary
                )
                pulseCard(
                    label: L10n.t("Week so far"),
                    primary: format.compact(weekTotal),
                    secondary: L10n.t("last 7 days"),
                    tint: Theme.textPrimary
                )
            }

            HStack(spacing: 8) {
                pulseCard(
                    label: L10n.t("Streak"),
                    primary: streak == 1 ? L10n.t("%d day", streak) : L10n.t("%d days", streak),
                    secondary: streak > 0 ? L10n.t("keep it going") : L10n.t("start today"),
                    tint: streak > 0 ? Theme.accent : Theme.textPrimary
                )
                pulseCard(
                    label: L10n.t("Last activity"),
                    primary: lastActivity.map(relativeDay) ?? "—",
                    secondary: lastActivity.map { format.compact($0.earnings) } ?? L10n.t("no recent work"),
                    tint: Theme.textPrimary
                )
            }

        }
    }

    private func currentStreak(points: [DailyPoint], todayStart: Date, calendar: Calendar) -> Int {
        var count = 0
        var cursor = todayStart
        let activeDates = Set(points
            .filter { $0.hours > 0 || $0.earnings > 0 }
            .map { calendar.startOfDay(for: $0.date) })
        while activeDates.contains(cursor) {
            count += 1
            guard let prev = calendar.date(byAdding: .day, value: -1, to: cursor) else { break }
            cursor = prev
        }
        return count
    }

    private func pulseCard(label: String, primary: String, secondary: String, tint: Color) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(Theme.body(size: 10, weight: .medium))
                .foregroundStyle(Theme.textTertiary)
                .textCase(.uppercase)
                .tracking(0.6)
            Text(primary)
                .font(Theme.body(size: 16, weight: .semibold))
                .foregroundStyle(tint)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
            Text(secondary)
                .font(Theme.body(size: 11))
                .foregroundStyle(Theme.textSecondary)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Theme.surface.opacity(0.7))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Theme.divider, lineWidth: 0.5)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(label): \(primary). \(secondary)")
    }

    private func relativeDay(_ point: DailyPoint) -> String {
        let cal = Calendar.current
        if cal.isDateInToday(point.date) { return L10n.t("Today") }
        if cal.isDateInYesterday(point.date) { return L10n.t("Yesterday") }
        let f = DateFormatter()
        f.locale = L10n.currentLocale
        f.setLocalizedDateFormatFromTemplate("EEE MMM d")
        return f.string(from: point.date)
    }
}
