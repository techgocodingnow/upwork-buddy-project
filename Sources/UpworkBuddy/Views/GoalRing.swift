import SwiftUI

struct GoalRing: View {
    let progress: Double          // 0...1+ (>1 → over goal)
    let label: String             // small caption inside ring (e.g. "65%")
    var size: CGFloat = 56
    var lineWidth: CGFloat = 6

    var body: some View {
        let clamped = max(0, min(progress, 1))
        let isOver = progress > 1

        ZStack {
            Circle()
                .stroke(Theme.trackBg, lineWidth: lineWidth)

            Circle()
                .trim(from: 0, to: clamped)
                .stroke(
                    isOver ? Theme.accentDeep : Theme.accent,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.4), value: clamped)

            VStack(spacing: 0) {
                Text(label)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(isOver ? Theme.accentDeep : Theme.textPrimary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
            }
            .padding(2)
        }
        .frame(width: size, height: size)
        .accessibilityLabel("Goal progress \(Int(progress * 100)) percent")
    }
}
