import AppKit
import SwiftUI

@MainActor
enum SettingsWindow {
    private static var window: NSWindow?

    static func show(store: AppStore) {
        if let existing = window {
            existing.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
            return
        }

        let root = SettingsRootView()
            .environment(store)

        let hosting = NSHostingController(rootView: root)
        let win = NSWindow(contentViewController: hosting)
        win.setContentSize(NSSize(width: 720, height: 540))
        win.minSize = NSSize(width: 640, height: 480)
        win.title = "UpworkBuddy Settings"
        win.titlebarAppearsTransparent = true
        win.titleVisibility = .hidden
        win.styleMask.insert(.fullSizeContentView)
        win.isReleasedWhenClosed = false
        win.center()
        win.delegate = SettingsWindowDelegate.shared

        window = win
        NSApp.activate(ignoringOtherApps: true)
        win.makeKeyAndOrderFront(nil)
    }

    static func didClose() {
        window = nil
    }
}

@MainActor
private final class SettingsWindowDelegate: NSObject, NSWindowDelegate {
    static let shared = SettingsWindowDelegate()
    func windowWillClose(_ notification: Notification) {
        SettingsWindow.didClose()
    }
}
