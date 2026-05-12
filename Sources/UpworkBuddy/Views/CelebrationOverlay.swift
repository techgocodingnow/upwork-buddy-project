import AppKit
import SwiftUI

/// Spans every connected display with a borderless, click-through, fully
/// transparent panel so the goal-hit confetti animation is visible regardless
/// of where the user is looking. Each panel auto-dismisses when its
/// `ConfettiView` reports completion.
///
/// Triggered via `AppStore.celebrate()`.
@MainActor
final class CelebrationOverlayController {
    static let shared = CelebrationOverlayController()

    private var activePanels: [UUID: [NSPanel]] = [:]

    private init() {}

    /// Spawn one overlay panel per connected screen for this token, and play
    /// the chosen sound once.
    func fire(
        token: UUID,
        style: CelebrationStyle,
        sound: CelebrationSound,
        customSource: String,
        palette: [Color]
    ) {
        guard activePanels[token] == nil else { return }

        var panels: [NSPanel] = []
        for screen in NSScreen.screens {
            let panel = makePanel(for: screen, token: token, style: style, palette: palette)
            panel.orderFrontRegardless()
            panels.append(panel)
        }
        activePanels[token] = panels

        CelebrationSoundPlayer.shared.play(sound, customSource: customSource)
    }

    /// Play a sound without spawning the overlay — used by Settings preview.
    func previewSound(_ sound: CelebrationSound, customSource: String = "") {
        CelebrationSoundPlayer.shared.play(sound, customSource: customSource)
    }

    private func makePanel(
        for screen: NSScreen,
        token: UUID,
        style: CelebrationStyle,
        palette: [Color]
    ) -> NSPanel {
        let panel = NSPanel(
            contentRect: screen.frame,
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )
        panel.isReleasedWhenClosed = false
        panel.isOpaque = false
        panel.backgroundColor = .clear
        panel.hasShadow = false
        panel.ignoresMouseEvents = true
        panel.level = .popUpMenu
        panel.hidesOnDeactivate = false
        panel.collectionBehavior = [
            .canJoinAllSpaces,
            .stationary,
            .ignoresCycle,
            .fullScreenAuxiliary
        ]
        panel.setFrame(screen.frame, display: false)

        let hosting = NSHostingController(
            rootView: ConfettiView(palette: palette, style: style) { [weak self, weak panel] in
                guard let self else { return }
                panel?.orderOut(nil)
                self.dismissPanel(token: token, panel: panel)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
        )
        hosting.view.frame = NSRect(origin: .zero, size: screen.frame.size)
        hosting.view.wantsLayer = true
        hosting.view.layer?.backgroundColor = .clear

        panel.contentViewController = hosting
        return panel
    }

    private func dismissPanel(token: UUID, panel: NSPanel?) {
        guard var remaining = activePanels[token] else { return }
        remaining.removeAll { $0 === panel }
        if remaining.isEmpty {
            activePanels.removeValue(forKey: token)
        } else {
            activePanels[token] = remaining
        }
    }
}
