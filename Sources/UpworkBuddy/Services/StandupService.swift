import AppKit
import Foundation
import Observation

/// Schedules and runs periodic standup / movement sessions: pause the Upwork
/// refresh loop, show a fullscreen lock overlay across (configured) screens,
/// count down, then resume refresh. Reacts to `AppStore.standupEnabled`
/// toggles. Defaults follow common ergonomic guidance (e.g. Stanford EHS
/// microbreaks): a 30-minute interval with a ~2-minute active break.
///
/// Consults `ExerciseCoordinator.shared` before firing so it never collides
/// with an active Eye Break (or other exercise).
@MainActor
final class StandupService {
    static let shared = StandupService()

    private weak var store: AppStore?
    private var scheduleTask: Task<Void, Never>?
    private var countdownTask: Task<Void, Never>?

    /// Hard-cap so a stuck overlay never traps the user past this many seconds.
    private let safetyCapSeconds: Int = 600

    /// Poll interval when waiting for the coordinator to clear another exercise.
    private let collisionRecheckSeconds: UInt64 = 30

    private init() {}

    /// Wire up the service to a store. Begins observing `standupEnabled` and
    /// starts the schedule loop if the feature is currently on.
    func start(store: AppStore) {
        self.store = store
        observeEnabledFlag()
        reconcile()
    }

    /// Trigger a standup immediately (used by the Settings preview button and
    /// by the scheduler when the interval elapses).
    func triggerBreak(durationOverride: Int? = nil) {
        guard let store, !store.isStandupActive else { return }
        guard ExerciseCoordinator.shared.canFire(.standup) else { return }

        let configured = max(1, durationOverride ?? store.standupDurationSeconds)
        let duration = min(configured, safetyCapSeconds)

        store.isStandupActive = true
        store.standupRemainingSeconds = duration

        ExerciseCoordinator.shared.markActive(.standup)
        NotificationCenter.default.post(
            name: .exerciseBegan,
            object: nil,
            userInfo: [ExerciseNotificationKey.kind: ExerciseCoordinator.Kind.standup.rawValue]
        )

        ExerciseOverlayController.shared.show(
            store: store,
            kind: .standup,
            externalOnly: store.standupExternalDisplaysOnly,
            onSkip: { [weak self] in self?.endCurrentBreak(resumeRefresh: true) }
        )

        countdownTask?.cancel()
        countdownTask = Task { [weak self] in
            await self?.runCountdown()
        }
    }

    /// End the current standup (user pressed Esc / Skip, countdown reached 0,
    /// or feature was disabled mid-break).
    func endCurrentBreak(resumeRefresh: Bool) {
        countdownTask?.cancel()
        countdownTask = nil

        ExerciseOverlayController.shared.hide()

        if let store {
            store.isStandupActive = false
            store.standupRemainingSeconds = 0
        }

        ExerciseCoordinator.shared.markIdle(.standup)

        if resumeRefresh {
            NotificationCenter.default.post(
                name: .exerciseEnded,
                object: nil,
                userInfo: [ExerciseNotificationKey.kind: ExerciseCoordinator.Kind.standup.rawValue]
            )
        }
    }

    // MARK: - Scheduling

    private func reconcile() {
        guard let store else { return }
        if store.standupEnabled {
            startScheduleLoop()
        } else {
            stopScheduleLoop()
            if store.isStandupActive {
                endCurrentBreak(resumeRefresh: true)
            }
        }
    }

    private func startScheduleLoop() {
        scheduleTask?.cancel()
        scheduleTask = Task { [weak self] in
            while !Task.isCancelled {
                guard let self, let store = self.store, store.standupEnabled else { return }
                let minutes = max(1, store.standupIntervalMinutes)
                let nanos = UInt64(minutes) * 60 * 1_000_000_000
                try? await Task.sleep(nanoseconds: nanos)
                if Task.isCancelled { return }
                guard let store = self.store, store.standupEnabled else { return }

                while !Task.isCancelled,
                      !ExerciseCoordinator.shared.canFire(.standup) {
                    try? await Task.sleep(nanoseconds: self.collisionRecheckSeconds * 1_000_000_000)
                }
                if Task.isCancelled { return }

                if !store.isStandupActive {
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
            guard let store = self.store, store.isStandupActive else { return }
            let next = store.standupRemainingSeconds - 1
            store.standupRemainingSeconds = max(0, next)
            if next <= 0 {
                endCurrentBreak(resumeRefresh: true)
                return
            }
        }
    }

    // MARK: - Observation

    private func observeEnabledFlag() {
        withObservationTracking { [weak self] in
            guard let self, let store = self.store else { return }
            _ = store.standupEnabled
            _ = store.standupIntervalMinutes
        } onChange: { [weak self] in
            DispatchQueue.main.async {
                self?.reconcile()
                self?.observeEnabledFlag()
            }
        }
    }
}
