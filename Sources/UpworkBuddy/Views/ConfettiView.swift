import SwiftUI

/// Lightweight confetti / firework overlay rendered via Canvas + TimelineView.
/// Self-driving: starts a 2.5s burst on appear, then calls `onFinished`.
struct ConfettiView: View {
    let palette: [Color]
    var duration: Double = 2.5
    let onFinished: () -> Void

    @State private var particles: [Particle] = []
    @State private var startedAt: Date = .distantFuture
    @State private var finishedFired = false

    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 60.0, paused: false)) { ctx in
            let elapsed = ctx.date.timeIntervalSince(startedAt)
            Canvas { gctx, size in
                drawParticles(into: gctx, size: size, elapsed: max(0, elapsed))
            }
            .allowsHitTesting(false)
            .onChange(of: elapsed) { _, t in
                if t >= duration && !finishedFired {
                    finishedFired = true
                    onFinished()
                }
            }
        }
        .onAppear {
            particles = Particle.makeBurst(count: 90, palette: palette)
            startedAt = Date()
        }
        .accessibilityHidden(true)
    }

    private func drawParticles(into gctx: GraphicsContext, size: CGSize, elapsed: Double) {
        let progress = min(1, elapsed / duration)
        // Global fade in last 25%.
        let alpha = progress < 0.75 ? 1.0 : 1.0 - ((progress - 0.75) / 0.25)

        for p in particles {
            let t = max(0, elapsed - p.delay)
            guard t > 0 else { continue }

            // Firework-style: explode outward, then drift down with sway.
            let burstT = min(1, t / 0.45)                    // 0…0.45s = burst out
            let burstEase = 1 - pow(1 - burstT, 3)            // easeOutCubic
            let burstR = burstEase * p.burstRadius

            let originX = size.width * 0.5
            let originY = size.height * 0.42
            let burstX = originX + cos(p.angle) * burstR
            let burstY = originY + sin(p.angle) * burstR

            let fallT = max(0, t - 0.45)
            let gravity = 360.0 * fallT * fallT * 0.5         // px
            let drift = sin((t * p.swaySpeed) + p.swayPhase) * p.swayAmplitude

            let x = burstX + drift
            let y = burstY + gravity

            let rotation = p.spin * t

            var path = Path()
            let rect = CGRect(x: -p.size.width / 2,
                              y: -p.size.height / 2,
                              width: p.size.width,
                              height: p.size.height)
            path.addRoundedRect(in: rect, cornerSize: CGSize(width: 1.2, height: 1.2))

            let transform = CGAffineTransform.identity
                .translatedBy(x: x, y: y)
                .rotated(by: rotation)
            let transformedPath = path.applying(transform)
            gctx.fill(transformedPath, with: .color(p.color.opacity(alpha)))
        }
    }
}

private struct Particle: Identifiable {
    let id = UUID()
    let color: Color
    let angle: Double          // radians (full 360 burst)
    let burstRadius: Double    // px outward at peak burst
    let size: CGSize
    let spin: Double           // rad/sec
    let swaySpeed: Double      // rad/sec
    let swayAmplitude: Double  // px
    let swayPhase: Double      // rad
    let delay: Double          // seconds before the particle activates

    static func makeBurst(count: Int, palette: [Color]) -> [Particle] {
        let safePalette: [Color] = palette.isEmpty
            ? [.red, .orange, .yellow, .green, .blue, .pink, .purple]
            : palette
        return (0..<count).map { _ in
            let angle = Double.random(in: 0...(2 * .pi))
            let radius = Double.random(in: 80...260)
            let w = CGFloat.random(in: 6...11)
            let h = CGFloat.random(in: 8...14)
            return Particle(
                color: safePalette.randomElement() ?? .accentColor,
                angle: angle,
                burstRadius: radius,
                size: CGSize(width: w, height: h),
                spin: Double.random(in: -8...8),
                swaySpeed: Double.random(in: 2.5...5.0),
                swayAmplitude: Double.random(in: 6...22),
                swayPhase: Double.random(in: 0...(2 * .pi)),
                delay: Double.random(in: 0...0.05)
            )
        }
    }
}
