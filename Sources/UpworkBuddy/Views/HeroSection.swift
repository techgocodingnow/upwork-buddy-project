import SwiftUI

struct HeroSection: View {
    let snapshot: EarningsSnapshot
    let period: Period
    let currency: String
    var masked: Bool = false
    var primary: MenuBarMetric = .earnings

    var body: some View {
        let format = CurrencyFormat(code: currency, masked: masked)
        let earningsText = format.string(snapshot.totalEarnings)
        let hoursText = snapshot.totalHours.asHours()
        let projectsText = "\(snapshot.projects.count) project\(snapshot.projects.count == 1 ? "" : "s")"

        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Circle().fill(Theme.accent).frame(width: 5, height: 5)
                Text(period.label)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Theme.textPrimary)
                Text("·").foregroundStyle(Theme.textTertiary)
                Text(headerSubtitle)
                    .font(.system(size: 12))
                    .foregroundStyle(Theme.textTertiary)
            }

            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Text(primary == .earnings ? earningsText : hoursText)
                    .font(.system(size: 36, weight: .bold, design: .default))
                    .foregroundStyle(Theme.accentDeep)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .layoutPriority(1)
                Spacer(minLength: 8)
                VStack(alignment: .trailing, spacing: 2) {
                    Text(primary == .earnings ? hoursText : earningsText)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Theme.textSecondary)
                    Text(projectsText)
                        .font(.system(size: 12))
                        .foregroundStyle(Theme.textTertiary)
                }
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
}
