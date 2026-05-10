import SwiftUI

struct ProjectsList: View {
    let projects: [ProjectStat]
    let currency: String
    var masked: Bool = false

    var body: some View {
        let format = CurrencyFormat(code: currency, masked: masked)
        let maxEarnings = max(projects.map(\.earnings).max() ?? 1, 0.01)

        VStack(alignment: .leading, spacing: 10) {
            HStack {
                SectionDotLabel(title: "Activity")
                Spacer()
                Text(loc: "Earnings")
                    .font(.system(size: 11))
                    .foregroundStyle(Theme.textTertiary)
                    .frame(width: 70, alignment: .trailing)
                Text(loc: "Hours")
                    .font(.system(size: 11))
                    .foregroundStyle(Theme.textTertiary)
                    .frame(width: 50, alignment: .trailing)
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
                            maxEarnings: maxEarnings
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
    let maxEarnings: Double

    var body: some View {
        HStack(spacing: 10) {
            BarTrack(progress: project.earnings / maxEarnings)
                .frame(width: 86, height: 6)
                .accessibilityHidden(true)

            Text(project.title)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(Theme.textPrimary)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text(format.compact(project.earnings))
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(Theme.textPrimary)
                .frame(width: 70, alignment: .trailing)

            Text(project.hours.asHours())
                .font(.system(size: 12))
                .foregroundStyle(Theme.textSecondary)
                .frame(width: 50, alignment: .trailing)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(project.title): \(format.compact(project.earnings)), \(project.hours.asHours())")
    }
}

private struct BarTrack: View {
    let progress: Double

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule().fill(Theme.trackBg)
                Capsule()
                    .fill(Theme.accent)
                    .frame(width: max(4, geo.size.width * CGFloat(min(max(progress, 0), 1))))
            }
        }
    }
}
