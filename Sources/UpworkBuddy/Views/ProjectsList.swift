import SwiftUI

struct ProjectsList: View {
    let projects: [ProjectStat]
    let currency: String
    var masked: Bool = false

    var body: some View {
        let format = CurrencyFormat(code: currency, masked: masked)
        let totalEarnings = max(projects.map(\.earnings).reduce(0, +), 0.01)

        VStack(alignment: .leading, spacing: 10) {
            HStack {
                SectionDotLabel(title: "Activity")
                Spacer()
                Text(loc: "Earnings")
                    .font(Theme.body(size: 11))
                    .foregroundStyle(Theme.textTertiary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .frame(width: 76, alignment: .trailing)
                Text(loc: "Hours")
                    .font(Theme.body(size: 11))
                    .foregroundStyle(Theme.textTertiary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .frame(width: 64, alignment: .trailing)
            }

            if projects.isEmpty {
                Text(loc: "No tracked work in this period.")
                    .font(.callout)
                    .foregroundStyle(Theme.textTertiary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 24)
            } else {
                VStack(spacing: 8) {
                    ForEach(projects) { project in
                        ProjectRow(
                            project: project,
                            format: format,
                            totalEarnings: totalEarnings
                        )
                    }
                }
            }
        }
    }
}

private struct ProjectRow: View {
    let project: ProjectStat
    let format: CurrencyFormat
    let totalEarnings: Double

    @State private var isNameHovered = false

    var body: some View {
        let share = Int(((project.earnings / totalEarnings) * 100).rounded())
        let earningsText = format.compact(project.earnings).replacingOccurrences(of: " ", with: "\u{00a0}")
        let hoursText = project.hours.asHours().replacingOccurrences(of: " ", with: "\u{00a0}")

        HStack(spacing: 10) {
            Text("\(share)%")
                .font(Theme.body(size: 12, weight: .semibold))
                .monospacedDigit()
                .foregroundStyle(Theme.accent)
                .frame(width: 34, alignment: .leading)

            Text(project.title)
                .font(Theme.body(size: 13, weight: .medium))
                .foregroundStyle(Theme.textPrimary)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
                .overlay(alignment: .topLeading) {
                    if isNameHovered {
                        nameTooltip
                            .offset(y: -36)
                            .allowsHitTesting(false)
                            .transition(.opacity)
                    }
                }
                .onHover { isNameHovered = $0 }
                .zIndex(isNameHovered ? 10 : 0)

            Text(earningsText)
                .font(Theme.body(size: 13, weight: .semibold))
                .foregroundStyle(Theme.textPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.75)
                .allowsTightening(true)
                .frame(width: 76, alignment: .trailing)

            Text(hoursText)
                .font(Theme.body(size: 12))
                .foregroundStyle(Theme.textSecondary)
                .lineLimit(1)
                .minimumScaleFactor(0.75)
                .allowsTightening(true)
                .frame(width: 64, alignment: .trailing)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(project.title): \(share)% of total, \(format.compact(project.earnings)), \(project.hours.asHours())")
    }

    private var nameTooltip: some View {
        Text(project.title)
            .font(Theme.body(size: 11, weight: .semibold))
            .foregroundStyle(Theme.textPrimary)
            .lineLimit(nil)
            .multilineTextAlignment(.leading)
            .padding(.horizontal, 10)
            .padding(.vertical, 7)
            .frame(maxWidth: 320, alignment: .leading)
            .fixedSize(horizontal: false, vertical: true)
            .background(
                RoundedRectangle(cornerRadius: Theme.radius(8))
                    .fill(Theme.surface)
            )
            .overlay(
                RoundedRectangle(cornerRadius: Theme.radius(8))
                    .strokeBorder(Theme.divider, lineWidth: 0.5)
            )
            .shadow(color: Color.black.opacity(0.22), radius: 8, y: 2)
    }
}
