import AppKit
import SwiftUI

@MainActor
enum SettingsWindow {
    private static var window: NSWindow?

    static func show(store: AppStore) {
        if let existing = window {
            applyAppearance(existing, store: store)
            existing.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
            return
        }

        let root = SettingsRootView()
            .environment(store)

        let hosting = NSHostingController(rootView: root)
        let win = NSWindow(contentViewController: hosting)
        win.setContentSize(NSSize(width: 820, height: 580))
        win.minSize = NSSize(width: 760, height: 520)
        win.title = "UpworkBuddy Settings"
        win.titlebarAppearsTransparent = true
        win.titleVisibility = .hidden
        win.styleMask.insert(.fullSizeContentView)
        win.isReleasedWhenClosed = false
        win.center()
        win.delegate = SettingsWindowDelegate.shared

        applyAppearance(win, store: store)
        observeAppearance(window: win, store: store)

        window = win
        NSApp.activate(ignoringOtherApps: true)
        win.makeKeyAndOrderFront(nil)
    }

    static func didClose() {
        window = nil
    }

    private static func applyAppearance(_ win: NSWindow, store: AppStore) {
        win.appearance = nsAppearance(for: store.appAppearance)
    }

    private static func observeAppearance(window win: NSWindow, store: AppStore) {
        withObservationTracking {
            _ = store.appAppearance
        } onChange: {
            DispatchQueue.main.async {
                guard let current = window else { return }
                applyAppearance(current, store: store)
                observeAppearance(window: current, store: store)
            }
        }
    }
}

@MainActor
private final class SettingsWindowDelegate: NSObject, NSWindowDelegate {
    static let shared = SettingsWindowDelegate()
    func windowWillClose(_ notification: Notification) {
        SettingsWindow.didClose()
    }
}
