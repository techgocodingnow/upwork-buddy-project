import SwiftUI

/// Celebration overlay particle effect. Each `CelebrationStyle` is rendered by a
/// small native particle engine (`TimelineView` + `Canvas`) — no third-party
/// dependency and no bundled resources. Self-driving: schedules `onFinished`
/// after `duration` so the host panel can tear itself down.
///
/// Particles use analytic motion (position is a pure function of elapsed time),
/// so there is no per-frame mutable state — `Canvas` simply redraws each tick.
/// All motion is in normalized space (`0...1` on each axis) and scaled to the
/// view size at draw time, keeping effects resolution-independent.
struct ConfettiView: View {
    let palette: [Color]
    var style: CelebrationStyle = .fireworks
    var duration: Double = 3.0
    let onFinished: () -> Void

    @State private var start = Date()
    @State private var system: ParticleSystem
    @State private var finishedFired = false

    init(
        palette: [Color],
        style: CelebrationStyle = .fireworks,
        duration: Double = 3.0,
        onFinished: @escaping () -> Void
    ) {
        self.palette = palette
        self.style = style
        self.duration = duration
        self.onFinished = onFinished
        _system = State(
            initialValue: ParticleSystem(style: style, palette: palette, duration: duration)
        )
    }

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                system.draw(
                    into: context,
                    size: size,
                    elapsed: timeline.date.timeIntervalSince(start)
                )
            }
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
}

// MARK: - Particle model

private struct Particle {
    enum Shape { case circle, rect, streak, money }

    let birth: Double          // seconds after start (may be negative: already in flight)
    let life: Double           // seconds visible
    let x0: CGFloat            // initial position, width fraction (0...1)
    let y0: CGFloat            // initial position, height fraction (0...1)
    let vx: CGFloat           // velocity, width fractions / s
    let vy: CGFloat           // velocity, height fractions / s
    let gravity: CGFloat      // downward acceleration, height fractions / s²
    let swayAmp: CGFloat      // horizontal sway amplitude, width fractions
    let swayFreq: CGFloat     // horizontal sway frequency, rad / s
    let size: CGFloat         // points
    let color: Color
    let shape: Shape
    let spin: Double          // rotation rate, rad / s
    let phase: Double         // initial rotation / sway phase, rad
    let fades: Bool           // burst particles fade out; streams just exit offscreen
    let additive: Bool        // plusLighter blend for glow (fireworks)
}

// MARK: - Particle system

/// Pre-computes a fixed particle set for a style at init, then draws it
/// analytically for any elapsed time. Drawing is pure given `elapsed`.
private struct ParticleSystem {
    let particles: [Particle]

    init(style: CelebrationStyle, palette: [Color], duration: Double) {
        switch style {
        case .fireworks:    particles = Self.fireworks(palette: palette, duration: duration)
        case .confettiRain: particles = Self.confetti(palette: palette, duration: duration)
        case .moneyRain:    particles = Self.moneyRain(duration: duration)
        case .snow:         particles = Self.snow(duration: duration)
        case .rain:         particles = Self.rain(duration: duration)
        }
    }

    func draw(into context: GraphicsContext, size: CGSize, elapsed t: Double) {
        for p in particles {
            let age = t - p.birth
            guard age >= 0, age <= p.life else { continue }

            let x = p.x0
                + p.vx * CGFloat(age)
                + p.swayAmp * CGFloat(sin(Double(p.swayFreq) * age + p.phase))
            let y = p.y0
                + p.vy * CGFloat(age)
                + 0.5 * p.gravity * CGFloat(age * age)
            guard y < 1.15, y > -0.25 else { continue }

            let point = CGPoint(x: x * size.width, y: y * size.height)
            let f = age / p.life
            let opacity = p.fades
                ? min(1, f / 0.08) * (f > 0.7 ? max(0, (1 - f) / 0.3) : 1)
                : 1

            var ctx = context
            ctx.opacity = opacity
            if p.additive { ctx.blendMode = .plusLighter }

            switch p.shape {
            case .circle:
                let r = p.size / 2
                ctx.fill(
                    Path(ellipseIn: CGRect(x: point.x - r, y: point.y - r, width: p.size, height: p.size)),
                    with: .color(p.color)
                )
            case .rect:
                ctx.translateBy(x: point.x, y: point.y)
                ctx.rotate(by: .radians(p.phase + p.spin * age))
                let w = p.size, h = p.size * 0.6
                ctx.fill(Path(CGRect(x: -w / 2, y: -h / 2, width: w, height: h)), with: .color(p.color))
            case .streak:
                let w: CGFloat = 2
                ctx.fill(
                    Path(roundedRect: CGRect(x: point.x - w / 2, y: point.y, width: w, height: p.size), cornerRadius: 1),
                    with: .color(p.color)
                )
            case .money:
                ctx.translateBy(x: point.x, y: point.y)
                ctx.rotate(by: .radians(p.phase + p.spin * age * 0.5))
                ctx.draw(Text("💵").font(.system(size: p.size)), at: .zero)
            }
        }
    }

    // MARK: - Emitters

    /// A handful of radial bursts at random upper-area centers, staggered in time.
    private static func fireworks(palette: [Color], duration: Double) -> [Particle] {
        var out: [Particle] = []
        for _ in 0..<5 {
            let burstTime = Double.random(in: 0...(duration * 0.55))
            let cx = CGFloat.random(in: 0.2...0.8)
            let cy = CGFloat.random(in: 0.2...0.45)
            let color = palette.randomElement() ?? .white
            for _ in 0..<Int.random(in: 32...46) {
                let angle = Double.random(in: 0..<(2 * .pi))
                let speed = CGFloat.random(in: 0.12...0.34)
                out.append(Particle(
                    birth: burstTime, life: Double.random(in: 0.9...1.5),
                    x0: cx, y0: cy,
                    vx: CGFloat(cos(angle)) * speed,
                    vy: CGFloat(sin(angle)) * speed * 0.6,
                    gravity: 0.35, swayAmp: 0, swayFreq: 0,
                    size: CGFloat.random(in: 3...6), color: color, shape: .circle,
                    spin: 0, phase: 0, fades: true, additive: true
                ))
            }
        }
        return out
    }

    /// Two outward bursts from center with an upward bias; spinning rectangles
    /// pulled down by gravity.
    private static func confetti(palette: [Color], duration: Double) -> [Particle] {
        var out: [Particle] = []
        for burstTime in [0.0, 0.5] {
            for _ in 0..<70 {
                let angle = Double.random(in: 0..<(2 * .pi))
                let speed = CGFloat.random(in: 0.1...0.5)
                out.append(Particle(
                    birth: burstTime, life: Double.random(in: 1.5...2.4),
                    x0: 0.5, y0: 0.45,
                    vx: CGFloat(cos(angle)) * speed,
                    vy: CGFloat(sin(angle)) * speed - 0.2,
                    gravity: 0.8, swayAmp: 0, swayFreq: 0,
                    size: CGFloat.random(in: 8...14),
                    color: palette.randomElement() ?? .white, shape: .rect,
                    spin: Double.random(in: -6...6),
                    phase: Double.random(in: 0..<(2 * .pi)), fades: true, additive: false
                ))
            }
        }
        return out
    }

    /// Continuous downward stream of dollar bills; some already falling at t=0.
    private static func moneyRain(duration: Double) -> [Particle] {
        (0..<28).map { _ in
            Particle(
                birth: Double.random(in: -3...duration), life: 4,
                x0: CGFloat.random(in: 0.05...0.95), y0: -0.1,
                vx: CGFloat.random(in: -0.03...0.03),
                vy: CGFloat.random(in: 0.28...0.42),
                gravity: 0.05,
                swayAmp: 0.02, swayFreq: CGFloat.random(in: 1...2.5),
                size: CGFloat.random(in: 34...46), color: .white, shape: .money,
                spin: Double.random(in: -1.5...1.5),
                phase: Double.random(in: 0..<(2 * .pi)), fades: false, additive: false
            )
        }
    }

    /// Slow drifting flakes with horizontal sway; continuous.
    private static func snow(duration: Double) -> [Particle] {
        (0..<60).map { _ in
            Particle(
                birth: Double.random(in: -6...duration), life: 8,
                x0: CGFloat.random(in: 0...1), y0: -0.05,
                vx: 0, vy: CGFloat.random(in: 0.08...0.16), gravity: 0,
                swayAmp: CGFloat.random(in: 0.02...0.05),
                swayFreq: CGFloat.random(in: 0.6...1.4),
                size: CGFloat.random(in: 5...13), color: .white, shape: .circle,
                spin: 0, phase: Double.random(in: 0..<(2 * .pi)), fades: false, additive: false
            )
        }
    }

    /// Fast, slightly angled vertical streaks; continuous.
    private static func rain(duration: Double) -> [Particle] {
        (0..<90).map { _ in
            Particle(
                birth: Double.random(in: -2...duration), life: 2,
                x0: CGFloat.random(in: -0.05...1), y0: -0.1,
                vx: 0.04, vy: CGFloat.random(in: 0.8...1.1), gravity: 0,
                swayAmp: 0, swayFreq: 0,
                size: CGFloat.random(in: 14...22), color: .white.opacity(0.6), shape: .streak,
                spin: 0, phase: 0, fades: false, additive: false
            )
        }
    }
}
