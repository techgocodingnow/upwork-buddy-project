import SwiftUI

struct HeroSection: View {
    let snapshot: EarningsSnapshot
    let previous: EarningsSnapshot
    let period: Period
    let currency: String
    var masked: Bool = false
    var primary: MenuBarMetric = .earnings
    /// Target value for the current `primary` metric. 0 hides the ring.
    var goalTarget: Double = 0

    var body: some View {
        let format = CurrencyFormat(code: currency, masked: masked)
        let earningsText = format.string(snapshot.totalEarnings)
        let hoursText = snapshot.totalHours.asHours()
        let projectsText = "\(snapshot.projects.count) project\(snapshot.projects.count == 1 ? "" : "s")"

        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Circle().fill(Theme.accent).frame(width: 5, height: 5)
                    .accessibilityHidden(true)
                Text(period.label)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Theme.textPrimary)
                Text("·").foregroundStyle(Theme.textTertiary)
                    .accessibilityHidden(true)
                Text(headerSubtitle)
                    .font(.system(size: 12))
                    .foregroundStyle(Theme.textTertiary)
                deltaChip(format: format)
            }

            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Text(primary == .earnings ? earningsText : hoursText)
                    .font(.system(size: 36, weight: .bold, design: .default))
                    .foregroundStyle(Theme.accentDeep)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .layoutPriority(1)
                    .accessibilityAddTraits(.isHeader)
                    .accessibilityLabel("\(period.label) \(primary == .earnings ? "earnings" : "hours"): \(primary == .earnings ? earningsText : hoursText)")
                Spacer(minLength: 8)
                if goalTarget > 0 {
                    let current = (primary == .earnings) ? snapshot.totalEarnings : snapshot.totalHours
                    let progress = current / goalTarget
                    GoalRing(
                        progress: progress,
                        label: "\(Int(progress * 100))%"
                    )
                }
                VStack(alignment: .trailing, spacing: 2) {
                    Text(primary == .earnings ? hoursText : earningsText)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Theme.textSecondary)
                    Text(projectsText)
                        .font(.system(size: 12))
                        .foregroundStyle(Theme.textTertiary)
                }
                .accessibilityElement(children: .combine)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 8)
    }

    private var headerSubtitle: String {
        let f = DateFormatter()
        f.dateFormat = "EEE MMM d"
        return f.string(from: Date())
    }

    @ViewBuilder
    private func deltaChip(format: CurrencyFormat) -> some View {
        let current = primary == .earnings ? snapshot.totalEarnings : snapshot.totalHours
        let prior = primary == .earnings ? previous.totalEarnings : previous.totalHours
        if prior > 0.01 {
            let delta = current - prior
            let pct = (delta / prior) * 100
            let positive = delta >= 0
            let tooltip = deltaTooltip(delta: delta, format: format)
            HStack(spacing: 3) {
                Image(systemName: positive ? "arrow.up.right" : "arrow.down.right")
                    .font(.system(size: 9, weight: .semibold))
                    .accessibilityHidden(true)
                Text(String(format: "%@%.0f%%", positive ? "+" : "", pct))
                    .font(.system(size: 11, weight: .semibold))
            }
            .foregroundStyle(positive ? Color.green.opacity(0.9) : Color.red.opacity(0.9))
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(
                Capsule().fill((positive ? Color.green : Color.red).opacity(0.12))
            )
            .help(tooltip)
            .accessibilityElement(children: .combine)
            .accessibilityLabel(tooltip)
        } else {
            EmptyView()
        }
    }

    private func deltaTooltip(delta: Double, format: CurrencyFormat) -> String {
        let prefix = (primary == .earnings ? "Earnings " : "Hours ")
        let value = primary == .earnings ? format.string(abs(delta)) : abs(delta).asHours()
        let direction = delta >= 0 ? "up" : "down"
        return "\(prefix)\(direction) \(value) vs \(period.previousLabel)"
    }
}

private extension Period {
    var previousLabel: String {
        switch self {
        case .today: return "yesterday"
        case .week:  return "last week"
        case .month: return "last month"
        case .year:  return "last year"
        }
    }
}
