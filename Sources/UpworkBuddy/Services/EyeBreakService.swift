import AppKit
import Foundation
import Observation

/// Unified notifications used by every exercise service to ask the app to
/// pause/resume the Upwork refresh loop. `userInfo["kind"]` carries the
/// raw value of `ExerciseCoordinator.Kind` for observers that care.
extension Notification.Name {
    static let exerciseBegan = Notification.Name("UpworkBuddyExerciseBegan")
    static let exerciseEnded = Notification.Name("UpworkBuddyExerciseEnded")
}

/// Key used inside `userInfo` of `.exerciseBegan` / `.exerciseEnded`.
enum ExerciseNotificationKey {
    static let kind = "kind"
}

/// Schedules and runs periodic eye-break sessions: pause the Upwork refresh
/// loop, show a fullscreen lock overlay across (configured) screens, count
/// down, then resume refresh. Reacts to `AppStore.eyeBreakEnabled` toggles.
///
/// Consults `ExerciseCoordinator.shared` before firing so it never collides
/// with another exercise (e.g. Standup) that may be active.
@MainActor
final class EyeBreakService {
    static let shared = EyeBreakService()

    private weak var store: AppStore?
    private var scheduleTask: Task<Void, Never>?
    private var countdownTask: Task<Void, Never>?

    /// Hard-cap so a stuck overlay never traps the user past this many seconds.
    private let safetyCapSeconds: Int = 600

    /// Poll interval when waiting for the coordinator to clear another exercise.
    private let collisionRecheckSeconds: UInt64 = 30

    private init() {}

    /// Wire up the service to a store. Begins observing `eyeBreakEnabled` and
    /// starts the schedule loop if the feature is currently on.
    func start(store: AppStore) {
        self.store = store
        observeEnabledFlag()
        reconcile()
    }

    /// Trigger a break immediately (used by the Settings preview button and
    /// by the scheduler when the interval elapses).
    func triggerBreak(durationOverride: Int? = nil) {
        guard let store, !store.isEyeBreakActive else { return }
        guard ExerciseCoordinator.shared.canFire(.eye) else { return }

        let configured = max(1, durationOverride ?? store.eyeBreakDurationSeconds)
        let duration = min(configured, safetyCapSeconds)

        store.isEyeBreakActive = true
        store.eyeBreakRemainingSeconds = duration

        ExerciseCoordinator.shared.markActive(.eye)
        NotificationCenter.default.post(
            name: .exerciseBegan,
            object: nil,
            userInfo: [ExerciseNotificationKey.kind: ExerciseCoordinator.Kind.eye.rawValue]
        )

        ExerciseOverlayController.shared.show(
            store: store,
            kind: .eye,
            externalOnly: store.eyeBreakExternalDisplaysOnly,
            onSkip: { [weak self] in self?.endCurrentBreak(resumeRefresh: true) }
        )

        countdownTask?.cancel()
        countdownTask = Task { [weak self] in
            await self?.runCountdown()
        }
    }

    /// End the current break (user pressed Esc / Skip, or countdown reached 0,
    /// or feature was disabled mid-break).
    func endCurrentBreak(resumeRefresh: Bool) {
        countdownTask?.cancel()
        countdownTask = nil

        ExerciseOverlayController.shared.hide()

        if let store {
            store.isEyeBreakActive = false
            store.eyeBreakRemainingSeconds = 0
        }

        ExerciseCoordinator.shared.markIdle(.eye)

        if resumeRefresh {
            NotificationCenter.default.post(
                name: .exerciseEnded,
                object: nil,
                userInfo: [ExerciseNotificationKey.kind: ExerciseCoordinator.Kind.eye.rawValue]
            )
        }
    }

    // MARK: - Scheduling

    private func reconcile() {
        guard let store else { return }
        if store.eyeBreakEnabled {
            startScheduleLoop()
        } else {
            stopScheduleLoop()
            if store.isEyeBreakActive {
                endCurrentBreak(resumeRefresh: true)
            }
        }
    }

    private func startScheduleLoop() {
        scheduleTask?.cancel()
        scheduleTask = Task { [weak self] in
            while !Task.isCancelled {
                guard let self, let store = self.store, store.eyeBreakEnabled else { return }
                let minutes = max(1, store.eyeBreakIntervalMinutes)
                let nanos = UInt64(minutes) * 60 * 1_000_000_000
                try? await Task.sleep(nanoseconds: nanos)
                if Task.isCancelled { return }
                guard let store = self.store, store.eyeBreakEnabled else { return }

                // Wait out any colliding exercise. The coordinator gates both
                // an active session and the post-end gap window.
                while !Task.isCancelled,
                      !ExerciseCoordinator.shared.canFire(.eye) {
                    try? await Task.sleep(nanoseconds: self.collisionRecheckSeconds * 1_000_000_000)
                }
                if Task.isCancelled { return }

                if !store.isEyeBreakActive {
                    self.triggerBreak()
                }
            }
        }
    }

    private func stopScheduleLoop() {
        scheduleTask?.cancel()
        scheduleTask = nil
    }

    private func runCountdown() async {
        while !Task.isCancelled {
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            if Task.isCancelled { return }
            guard let store = self.store, store.isEyeBreakActive else { return }
            let next = store.eyeBreakRemainingSeconds - 1
            store.eyeBreakRemainingSeconds = max(0, next)
            if next <= 0 {
                endCurrentBreak(resumeRefresh: true)
                return
            }
        }
    }

    // MARK: - Observation

    private func observeEnabledFlag() {
        // Re-arm observation on every fired change (Observation tracks once).
        withObservationTracking { [weak self] in
            guard let self, let store = self.store else { return }
            _ = store.eyeBreakEnabled
            _ = store.eyeBreakIntervalMinutes
        } onChange: { [weak self] in
            DispatchQueue.main.async {
                self?.reconcile()
                self?.observeEnabledFlag()
            }
        }
    }
}
