import SwiftUI

struct ProjectsList: View {
    let projects: [ProjectStat]
    let currency: String

    var body: some View {
        let format = CurrencyFormat(code: currency)
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("ACTIVE PROJECTS")
                    .font(.system(size: 10, weight: .semibold))
                    .tracking(1.2)
                    .foregroundStyle(.tertiary)
                Spacer()
                Text("\(projects.count)")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(.tertiary)
            }
            .padding(.horizontal, 4)
            .padding(.bottom, 6)

            if projects.isEmpty {
                Text("No tracked work in this period.")
                    .font(.callout)
                    .foregroundStyle(.tertiary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 24)
            } else {
                ForEach(projects) { project in
                    ProjectRow(project: project, format: format)
                    if project.id != projects.last?.id {
                        Divider().padding(.leading, 4)
                    }
                }
            }
        }
    }
}

private struct ProjectRow: View {
    let project: ProjectStat
    let format: CurrencyFormat

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Circle()
                .fill(Color.accentColor.opacity(0.18))
                .overlay {
                    Text(initials(project.title))
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(Color.accentColor)
                }
                .frame(width: 26, height: 26)
            VStack(alignment: .leading, spacing: 2) {
                Text(project.title)
                    .font(.system(size: 13, weight: .medium))
                    .lineLimit(1)
                HStack(spacing: 8) {
                    Text(project.hours.asHours())
                    if project.derivedRate > 0 {
                        Text("·")
                        Text(format.compact(project.derivedRate) + "/hr")
                    }
                }
                .font(.system(size: 11))
                .foregroundStyle(.tertiary)
            }
            Spacer()
            Text(format.string(project.earnings))
                .font(.system(size: 13, weight: .semibold, design: .rounded))
        }
        .padding(.horizontal, 4)
        .padding(.vertical, 8)
    }

    private func initials(_ title: String) -> String {
        let parts = title.split(separator: " ").prefix(2)
        return parts.compactMap { $0.first.map(String.init) }.joined().uppercased()
    }
}
