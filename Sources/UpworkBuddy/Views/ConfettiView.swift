import SwiftUI
import Vortex

/// Celebration overlay particle effect. Each `CelebrationStyle` maps to a
/// Vortex preset or small custom VortexSystem.  Self-driving: schedules
/// `onFinished` after `duration` so the host panel can tear itself down.
struct ConfettiView: View {
    let palette: [Color]
    var style: CelebrationStyle = .fireworks
    var duration: Double = 3.0
    let onFinished: () -> Void

    @State private var finishedFired = false

    var body: some View {
        ZStack {
            content
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
        .accessibilityHidden(true)
        .task {
            try? await Task.sleep(nanoseconds: UInt64(duration * 1_000_000_000))
            if !finishedFired {
                finishedFired = true
                onFinished()
            }
        }
    }

    // MARK: - Style routing

    @ViewBuilder
    private var content: some View {
        switch style {
        case .fireworks:    fireworksView
        case .confettiRain: confettiBurstView
        case .moneyRain:    moneyRainView
        case .snow:         snowView
        case .rain:         rainView
        }
    }

    // MARK: - Vortex preset views

    private var fireworksView: some View {
        VortexView(.fireworks) {
            Circle()
                .fill(.white)
                .blendMode(.plusLighter)
                .frame(width: 32, height: 32)
                .tag("circle")
        }
    }

    /// `.confetti` is burst-only. Trigger one burst on appear and another half
    /// a second in so the screen fills before the panel auto-dismisses.
    private var confettiBurstView: some View {
        VortexViewReader { proxy in
            VortexView(.confetti) {
                Rectangle()
                    .fill(.white)
                    .frame(width: 16, height: 16)
                    .tag("square")
                Circle()
                    .fill(.white)
                    .frame(width: 16, height: 16)
                    .tag("circle")
            }
            .onAppear {
                proxy.burst()
                Task {
                    try? await Task.sleep(nanoseconds: 500_000_000)
                    proxy.burst()
                }
            }
        }
    }

    private var moneyRainView: some View {
        VortexView(moneyRainSystem()) {
            Text("💵")
                .font(.system(size: 48))
                .tag("money")
        }
    }

    private var snowView: some View {
        VortexView(.snow) {
            Circle()
                .fill(.white)
                .blur(radius: 2)
                .frame(width: 24, height: 24)
                .tag("circle")
        }
    }

    private var rainView: some View {
        VortexView(.rain) {
            Circle()
                .fill(.white.opacity(0.7))
                .frame(width: 32, height: 32)
                .tag("circle")
        }
    }

    // MARK: - Custom VortexSystem builders

    /// Continuous downward stream of dollar bills from above the visible area.
    private func moneyRainSystem() -> VortexSystem {
        let s = VortexSystem(tags: ["money"])
        s.position = [0.5, -0.05]
        s.shape = .box(width: 1, height: 0)
        s.birthRate = 30
        s.lifespan = 4
        s.lifespanVariation = 1
        s.speed = 0.35
        s.speedVariation = 0.2
        s.angle = .degrees(180)
        s.angleRange = .degrees(10)
        s.size = 0.6
        s.sizeVariation = 0.5
        s.angularSpeedVariation = [0, 0, 2]
        return s
    }
}
