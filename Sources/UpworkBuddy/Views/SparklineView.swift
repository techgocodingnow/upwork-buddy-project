import SwiftUI

struct SparklineView: View {
    let points: [DailyPoint]
    let currency: String

    var body: some View {
        GeometryReader { geo in
            let values = points.map(\.earnings)
            let maxV = max(values.max() ?? 1, 0.01)
            let stepX = points.count > 1 ? geo.size.width / CGFloat(points.count - 1) : 0
            let path = Path { p in
                for (i, v) in values.enumerated() {
                    let x = CGFloat(i) * stepX
                    let y = geo.size.height - CGFloat(v / maxV) * geo.size.height
                    if i == 0 { p.move(to: CGPoint(x: x, y: y)) }
                    else { p.addLine(to: CGPoint(x: x, y: y)) }
                }
            }
            let fill = Path { p in
                p.addPath(path)
                p.addLine(to: CGPoint(x: geo.size.width, y: geo.size.height))
                p.addLine(to: CGPoint(x: 0, y: geo.size.height))
                p.closeSubpath()
            }
            ZStack {
                fill.fill(LinearGradient(
                    colors: [Color.accentColor.opacity(0.30), Color.accentColor.opacity(0.0)],
                    startPoint: .top,
                    endPoint: .bottom
                ))
                path.stroke(Color.accentColor, style: StrokeStyle(lineWidth: 1.5, lineJoin: .round))
            }
        }
        .frame(height: 56)
        .overlay(alignment: .topLeading) {
            if let last = points.last {
                Text(CurrencyFormat(code: currency).compact(last.earnings))
                    .font(.caption2.weight(.medium))
                    .foregroundStyle(.secondary)
                    .padding(4)
            }
        }
    }
}
