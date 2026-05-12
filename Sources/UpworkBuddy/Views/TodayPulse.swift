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

        let yesterdayPt = points.first {
            guard let y = cal.date(byAdding: .day, value: -1, to: todayStart) else { return false }
            return cal.isDate($0.date, inSameDayAs: y)
        }

        let todayEarn = snapshot.totalEarnings
        let yesterdayEarn = yesterdayPt?.earnings ?? 0

        let weekTotal: Double = {
            guard let weekStart = cal.date(byAdding: .day, value: -6, to: todayStart) else { return 0 }
            return points
                .filter { $0.date >= weekStart && $0.date <= todayStart }
                .reduce(0) { $0 + $1.earnings }
        }()

        let lastActivity = points
            .filter { $0.hours > 0 || $0.earnings > 0 }
            .max(by: { $0.date < $1.date })

        VStack(alignment: .leading, spacing: 10) {
            SectionDotLabel(title: "Today's pulse")

            HStack(spacing: 8) {
                pulseCard(
                    label: "Vs yesterday",
                    primary: deltaText(today: todayEarn, prior: yesterdayEarn, format: format),
                    secondary: format.compact(yesterdayEarn) + " yest.",
                    tint: deltaTint(today: todayEarn, prior: yesterdayEarn)
                )
                pulseCard(
                    label: "Week so far",
                    primary: format.compact(weekTotal),
                    secondary: "last 7 days",
                    tint: Theme.textPrimary
                )
            }

            HStack(spacing: 8) {
                pulseCard(
                    label: "Hours today",
                    primary: snapshot.totalHours.asHours(),
                    secondary: hoursContext(today: snapshot.totalHours, yesterday: yesterdayPt?.hours ?? 0),
                    tint: Theme.textPrimary
                )
                pulseCard(
                    label: "Last activity",
                    primary: lastActivity.map(relativeDay) ?? "—",
                    secondary: lastActivity.map { format.compact($0.earnings) } ?? "no recent work",
                    tint: Theme.textPrimary
                )
            }

        }
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

    private func deltaText(today: Double, prior: Double, format: CurrencyFormat) -> String {
        if prior <= 0 && today <= 0 { return "—" }
        if prior <= 0 { return "+" + format.compact(today) }
        let pct = (today - prior) / prior * 100
        let sign = pct >= 0 ? "+" : ""
        return "\(sign)\(Int(pct.rounded()))%"
    }

    private func deltaTint(today: Double, prior: Double) -> Color {
        if today >= prior { return Theme.accent }
        return Theme.textSecondary
    }

    private func hoursContext(today: Double, yesterday: Double) -> String {
        if yesterday <= 0 { return "—" }
        let diff = today - yesterday
        let prefix = diff >= 0 ? "+" : "−"
        return "\(prefix)\(abs(diff).asHours()) vs yest."
    }

    private func relativeDay(_ point: DailyPoint) -> String {
        let cal = Calendar.current
        if cal.isDateInToday(point.date) { return "Today" }
        if cal.isDateInYesterday(point.date) { return "Yesterday" }
        let f = DateFormatter()
        f.dateFormat = "EEE MMM d"
        return f.string(from: point.date)
    }
}
