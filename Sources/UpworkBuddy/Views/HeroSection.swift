import SwiftUI

struct HeroSection: View {
    let snapshot: EarningsSnapshot
    let period: Period
    let currency: String

    var body: some View {
        let format = CurrencyFormat(code: currency)
        VStack(alignment: .leading, spacing: 6) {
            Text(period.label.uppercased())
                .font(.caption2.weight(.semibold))
                .foregroundStyle(.tertiary)
                .tracking(1.2)
            HStack(alignment: .firstTextBaseline, spacing: 14) {
                Text(format.string(snapshot.totalEarnings))
                    .font(.system(size: 32, weight: .semibold, design: .rounded))
                    .foregroundStyle(.primary)
                Text(snapshot.totalHours.asHours())
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundStyle(.secondary)
            }
            HStack(spacing: 12) {
                Stat(label: "Projects", value: "\(snapshot.projects.count)")
                Stat(label: "Avg/hr", value: snapshot.totalHours > 0
                     ? format.compact(snapshot.totalEarnings / snapshot.totalHours)
                     : "—")
            }
            .padding(.top, 4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.accentColor.opacity(0.08))
        )
    }
}

private struct Stat: View {
    let label: String
    let value: String
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label.uppercased())
                .font(.system(size: 9, weight: .semibold))
                .tracking(1.0)
                .foregroundStyle(.tertiary)
            Text(value)
                .font(.system(size: 13, weight: .medium, design: .rounded))
                .foregroundStyle(.secondary)
        }
    }
}
