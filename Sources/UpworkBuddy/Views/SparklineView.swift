import SwiftUI

struct SparklineView: View {
    let points: [DailyPoint]
    let currency: String
    var masked: Bool = false

    @State private var hoverIndex: Int?

    var body: some View {
        let values = points.map(\.earnings)
        let maxV = max(values.max() ?? 1, 0.01)
        let total = values.reduce(0, +)
        let format = CurrencyFormat(code: currency, masked: masked)

        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Last \(points.count) days")
                        .font(.system(size: 11))
                        .foregroundStyle(Theme.textTertiary)
                    Text(format.compact(total))
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(Theme.textPrimary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                }
                Spacer()
            }

            GeometryReader { geo in
                let count = max(values.count, 1)
                let gap: CGFloat = 3
                let barW = max(2, (geo.size.width - CGFloat(count - 1) * gap) / CGFloat(count))

                ZStack(alignment: .topLeading) {
                    Rectangle()
                        .fill(Theme.divider)
                        .frame(height: 0.5)
                        .offset(y: geo.size.height * 0.5)

                    HStack(alignment: .bottom, spacing: gap) {
                        ForEach(Array(values.enumerated()), id: \.offset) { idx, v in
                            let h = max(2, CGFloat(v / maxV) * geo.size.height)
                            let isHover = hoverIndex == idx
                            RoundedRectangle(cornerRadius: 1.5)
                                .fill(barFill(value: v, hover: isHover))
                                .frame(width: barW, height: h)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 1.5)
                                        .stroke(Theme.accentDeep, lineWidth: isHover ? 1 : 0)
                                )
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)

                    HStack(spacing: gap) {
                        ForEach(Array(values.enumerated()), id: \.offset) { idx, _ in
                            Color.clear
                                .frame(width: barW)
                                .contentShape(Rectangle())
                                .onHover { inside in
                                    if inside { hoverIndex = idx }
                                    else if hoverIndex == idx { hoverIndex = nil }
                                }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .frame(height: 64)
            .overlay(alignment: .topLeading) {
                GeometryReader { geo in
                    let count = max(values.count, 1)
                    let gap: CGFloat = 3
                    let barW = max(2, (geo.size.width - CGFloat(count - 1) * gap) / CGFloat(count))
                    if let idx = hoverIndex, idx < points.count {
                        tooltip(for: points[idx], format: format)
                            .offset(
                                x: tooltipX(idx: idx, barW: barW, gap: gap, width: geo.size.width),
                                y: geo.size.height + 6
                            )
                    }
                }
                .allowsHitTesting(false)
            }
        }
    }

    private func barFill(value: Double, hover: Bool) -> Color {
        if hover { return Theme.accentDeep }
        return Theme.accent.opacity(value <= 0 ? 0.15 : 0.85)
    }

    private func tooltip(for point: DailyPoint, format: CurrencyFormat) -> some View {
        let f = DateFormatter()
        f.dateFormat = "EEE MMM d"
        let rows = Array(point.breakdown.prefix(5))
        return VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(f.string(from: point.date))
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(.white)
                Spacer(minLength: 12)
                Text(format.compact(point.earnings))
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(Theme.accentSoft)
            }
            if !rows.isEmpty {
                Rectangle().fill(.white.opacity(0.18)).frame(height: 0.5)
                ForEach(rows) { row in
                    HStack(spacing: 8) {
                        Circle().fill(Theme.accent).frame(width: 4, height: 4)
                        Text(row.label)
                            .font(.system(size: 11))
                            .foregroundStyle(.white)
                            .lineLimit(1)
                            .truncationMode(.tail)
                        Spacer(minLength: 8)
                        Text(format.compact(row.earnings))
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundStyle(Theme.accentSoft)
                        Text(row.hours.asHours())
                            .font(.system(size: 11))
                            .foregroundStyle(.white.opacity(0.7))
                            .frame(width: 36, alignment: .trailing)
                    }
                }
                if point.breakdown.count > rows.count {
                    Text("+\(point.breakdown.count - rows.count) more")
                        .font(.system(size: 10))
                        .foregroundStyle(.white.opacity(0.6))
                }
            } else {
                Text(point.hours.asHours())
                    .font(.system(size: 11))
                    .foregroundStyle(.white.opacity(0.7))
            }
        }
        .frame(width: 320, alignment: .leading)
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.black.opacity(0.92))
        )
        .fixedSize(horizontal: false, vertical: true)
        .shadow(color: .black.opacity(0.25), radius: 6, y: 2)
    }

    private func tooltipX(idx: Int, barW: CGFloat, gap: CGFloat, width: CGFloat) -> CGFloat {
        let center = CGFloat(idx) * (barW + gap) + barW / 2
        let tooltipW: CGFloat = 320
        let clamped = min(max(center - tooltipW / 2, 0), max(0, width - tooltipW))
        return clamped
    }
}
