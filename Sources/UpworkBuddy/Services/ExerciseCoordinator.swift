import Foundation

/// Arbitrates between exercise services (`EyeBreakService`, `StandupService`)
/// so the user is never hit by two fullscreen overlays at once. Each service
/// asks `canFire` before starting; if blocked, the service reschedules itself
/// and retries after a short delay.
@MainActor
final class ExerciseCoordinator {
    static let shared = ExerciseCoordinator()

    enum Kind: String, Sendable {
        case eye
        case standup

        var iconSystemName: String {
            switch self {
            case .eye:     return "eye"
            case .standup: return "figure.stand"
            }
        }
    }

    /// Currently running exercise, if any.
    private(set) var active: Kind?

    /// (kind, end-time) of the most recently completed exercise. Used to
    /// space out back-to-back firings of *different* kinds by `gapSeconds`.
    private var lastEnd: (kind: Kind, at: Date)?

    /// Minimum gap between two *different* exercises. Same-kind cadence is
    /// already governed by each exercise's own interval setting.
    var gapSeconds: Int = 5 * 60

    private init() {}

    /// Returns true if `kind` may start a session right now without
    /// colliding with another exercise (active or just-ended).
    func canFire(_ kind: Kind) -> Bool {
        if let active, active != kind { return false }
        if let lastEnd, lastEnd.kind != kind,
           Date().timeIntervalSince(lastEnd.at) < TimeInterval(gapSeconds) {
            return false
        }
        return true
    }

    func markActive(_ kind: Kind) {
        active = kind
    }

    func markIdle(_ kind: Kind) {
        guard active == kind else { return }
        active = nil
        lastEnd = (kind, Date())
    }
}
