import AppKit
import SwiftUI

/// Borderless NSPanel subclass that *can* become key/main. Required so the
/// overlay receives keyDown events (Esc to skip). The default borderless
/// panel returns false for `canBecomeKey`, which silently swallows keys.
private final class KeyableOverlayPanel: NSPanel {
    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { true }
}

/// Fullscreen "lock screen" style overlay shown during an exercise session
/// (eye break, standup, …). One opaque NSPanel per (filtered) NSScreen,
/// mouse/keyboard captured so the user is gently forced to take the break.
/// Esc dismisses early.
@MainActor
final class ExerciseOverlayController {
    static let shared = ExerciseOverlayController()

    private var activePanels: [NSPanel] = []
    private var keyMonitor: Any?
    private var onSkip: (() -> Void)?

    private init() {}

    var isShowing: Bool { !activePanels.isEmpty }

    /// Show one overlay per relevant screen. `externalOnly` filters out
    /// `NSScreen.main` so the laptop display stays usable.
    func show(
        store: AppStore,
        kind: ExerciseCoordinator.Kind,
        externalOnly: Bool,
        onSkip: @escaping () -> Void
    ) {
        guard activePanels.isEmpty else { return }
        self.onSkip = onSkip

        let screens = targetScreens(externalOnly: externalOnly)
        for screen in screens {
            let panel = makePanel(for: screen, store: store, kind: kind)
            panel.orderFrontRegardless()
            activePanels.append(panel)
        }

        // Activate the app and key the first panel so keyDown (Esc) routes
        // here instead of whatever app the user was in when the break fired.
        NSApp.activate(ignoringOtherApps: true)
        activePanels.first?.makeKeyAndOrderFront(nil)

        installKeyMonitor()
    }

    func hide() {
        if let monitor = keyMonitor {
            NSEvent.removeMonitor(monitor)
            keyMonitor = nil
        }
        for panel in activePanels {
            panel.orderOut(nil)
            panel.close()
        }
        activePanels.removeAll()
        onSkip = nil
    }

    private func targetScreens(externalOnly: Bool) -> [NSScreen] {
        let all = NSScreen.screens
        guard externalOnly else { return all }
        let main = NSScreen.main
        let filtered = all.filter { $0 != main }
        // If there are no external screens, fall back to main so the break
        // still triggers visibly rather than silently no-op'ing.
        return filtered.isEmpty ? all : filtered
    }

    private func installKeyMonitor() {
        keyMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] event in
            // 53 = Escape
            if event.keyCode == 53 {
                self?.onSkip?()
                return nil
            }
            return event
        }
    }

    private func makePanel(for screen: NSScreen, store: AppStore, kind: ExerciseCoordinator.Kind) -> NSPanel {
        let panel = KeyableOverlayPanel(
            contentRect: screen.frame,
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )
        panel.isReleasedWhenClosed = false
        panel.isOpaque = true
        panel.backgroundColor = .black
        panel.hasShadow = false
        panel.ignoresMouseEvents = false
        panel.level = .screenSaver
        panel.hidesOnDeactivate = false
        panel.becomesKeyOnlyIfNeeded = false
        panel.collectionBehavior = [
            .canJoinAllSpaces,
            .stationary,
            .ignoresCycle,
            .fullScreenAuxiliary
        ]
        panel.setFrame(screen.frame, display: false)

        let hosting = NSHostingController(
            rootView: ExerciseLockView(store: store, kind: kind) { [weak self] in
                self?.onSkip?()
            }
        )
        hosting.view.frame = NSRect(origin: .zero, size: screen.frame.size)
        panel.contentViewController = hosting
        return panel
    }
}

/// SwiftUI view rendered inside each overlay panel. Observes the store so
/// the countdown updates as the owning service decrements remaining seconds
/// for `kind`.
struct ExerciseLockView: View {
    @Bindable var store: AppStore
    let kind: ExerciseCoordinator.Kind
    let onSkip: () -> Void

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.02, green: 0.04, blue: 0.08),
                    Color(red: 0.06, green: 0.09, blue: 0.16)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 36) {
                Image(systemName: kind.iconSystemName)
                    .font(.system(size: 80, weight: .ultraLight))
                    .foregroundStyle(.white.opacity(0.85))
                    .accessibilityHidden(true)

                Text(formatted(remaining))
                    .font(.system(size: 140, weight: .thin, design: .monospaced))
                    .foregroundStyle(.white)
                    .monospacedDigit()
                    .contentTransition(.numericText(countsDown: true))
                    .animation(.snappy, value: remaining)
                    .accessibilityLabel(L10n.t("%@ remaining", formatted(remaining)))

                Text(message)
                    .font(.system(size: 22, weight: .regular))
                    .foregroundStyle(.white.opacity(0.92))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 60)
                    .frame(maxWidth: 720)

                Button(action: onSkip) {
                    Text(loc: "Skip break (Esc)")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.white.opacity(0.9))
                        .padding(.horizontal, 18)
                        .padding(.vertical, 10)
                        .overlay(
                            Capsule()
                                .strokeBorder(Color.white.opacity(0.45), lineWidth: 1)
                        )
                }
                .buttonStyle(.plain)
                .padding(.top, 12)
                .accessibilityLabel(L10n.t("Skip break"))
                .accessibilityHint(L10n.t("Press Escape or activate to skip the break early"))
            }
        }
    }

    private var remaining: Int {
        switch kind {
        case .eye:     return store.eyeBreakRemainingSeconds
        case .standup: return store.standupRemainingSeconds
        }
    }

    private var message: String {
        switch kind {
        case .eye:     return store.eyeBreakCustomText
        case .standup: return store.standupCustomText
        }
    }

    private func formatted(_ seconds: Int) -> String {
        let s = max(0, seconds)
        let m = s / 60
        let r = s % 60
        return String(format: "%02d:%02d", m, r)
    }
}
