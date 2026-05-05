import SwiftUI
import AppKit
import Observation

private let popoverWidth: CGFloat = 380
private let popoverHeight: CGFloat = 600
private let menubarTitleFontSize: CGFloat = 13
private let menubarIconPointSize: CGFloat = 16

@main
struct UpworkBuddyApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        Settings { EmptyView() }
    }
}

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate, NSPopoverDelegate {
    private var statusItem: NSStatusItem!
    private var popover: NSPopover!
    private let store = AppStore()
    private var refreshTask: Task<Void, Never>?
    private var observationToken: NSObjectProtocol?
    private var pendingStatusRefresh = false

    func applicationWillFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        ProcessInfo.processInfo.automaticTerminationSupportEnabled = false
        ProcessInfo.processInfo.disableSuddenTermination()

        OAuthCallbackBridge.shared.register { [weak self] result in
            Task { @MainActor in
                guard let self else { return }
                switch result {
                case .success:
                    await self.store.completeLogin()
                    self.refreshStatusButton()
                    NSApp.activate(ignoringOtherApps: true)
                    if let button = self.statusItem.button, !self.popover.isShown {
                        self.popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
                        self.popover.contentViewController?.view.window?.makeKey()
                    }
                case .failure(let error):
                    self.store.lastError = error.localizedDescription
                }
            }
        }

        setupStatusItem()
        setupPopover()
        startRefreshLoop()
        observeStore()

        Task { await store.bootstrap() }
    }

    // MARK: - Refresh loop

    private func startRefreshLoop() {
        refreshTask?.cancel()
        refreshTask = Task { [weak self] in
            while !Task.isCancelled {
                guard let self else { return }
                let interval = UInt64(self.store.refreshIntervalSeconds)
                try? await Task.sleep(nanoseconds: interval * 1_000_000_000)
                await self.store.refresh(force: true)
                self.refreshStatusButton()
            }
        }
    }

    private func observeStore() {
        withObservationTracking {
            _ = store.todaySnapshot
            _ = store.snapshot
            _ = store.isAuthenticated
            _ = store.hideSensitive
        } onChange: { [weak self] in
            DispatchQueue.main.async {
                self?.refreshStatusButton()
                self?.observeStore()
            }
        }
    }

    // MARK: - Status item

    private func setupStatusItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        guard let button = statusItem.button else { return }

        let icon = makeMenuBarIcon()
        button.image = icon
        button.imagePosition = .imageLeading

        button.target = self
        button.action = #selector(handleButtonClick(_:))
        button.sendAction(on: [.leftMouseUp, .rightMouseUp])

        DispatchQueue.main.async { [weak self] in self?.refreshStatusButton() }
    }

    private func refreshStatusButton() {
        guard let button = statusItem.button else { return }

        // Avoid resizing the status item while the popover is open — its anchor
        // becomes invalid mid-update and NSPopover snaps to the screen corner.
        if popover?.isShown == true {
            pendingStatusRefresh = true
            return
        }

        // Drop the standalone image — the attributed title carries the icon
        // via NSTextAttachment. Leaving both set duplicates the briefcase.
        button.image = nil
        button.imagePosition = .noImage

        let font = NSFont.monospacedDigitSystemFont(ofSize: menubarTitleFontSize, weight: .medium)
        let icon = makeMenuBarIcon()

        let attachment = NSTextAttachment()
        attachment.image = icon
        if let size = icon?.size {
            attachment.bounds = CGRect(x: 0, y: -3, width: size.width, height: size.height)
        }

        let valueText: String
        let attrs: [NSAttributedString.Key: Any]
        if store.isAuthenticated {
            let amount = store.todaySnapshot.totalEarnings
            let formatter = CurrencyFormat(code: store.currency, masked: store.hideSensitive)
            valueText = " " + (amount > 0 || store.hideSensitive ? formatter.compact(amount) : "$—")
            attrs = [.font: font, .baselineOffset: -1.0]
        } else {
            valueText = ""
            attrs = [.font: font, .baselineOffset: -1.0, .foregroundColor: NSColor.secondaryLabelColor]
        }

        let composed = NSMutableAttributedString()
        composed.append(NSAttributedString(attachment: attachment))
        if !valueText.isEmpty {
            composed.append(NSAttributedString(string: valueText, attributes: attrs))
        }
        button.attributedTitle = composed
    }

    // MARK: - Popover

    private func setupPopover() {
        popover = NSPopover()
        popover.contentSize = NSSize(width: popoverWidth, height: popoverHeight)
        popover.behavior = .transient
        popover.animates = true
        popover.delegate = self

        let content = MenuBarContent()
            .environment(store)
            .frame(width: popoverWidth)

        popover.contentViewController = NSHostingController(rootView: content)
    }

    @objc private func handleButtonClick(_ sender: AnyObject?) {
        guard let button = statusItem.button,
              let event = NSApp.currentEvent else { return }

        if event.type == .rightMouseUp {
            showContextMenu(from: button)
            return
        }

        if popover.isShown {
            popover.performClose(sender)
        } else {
            NSApp.activate(ignoringOtherApps: true)
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            popover.contentViewController?.view.window?.makeKey()
        }
    }

    private func showContextMenu(from button: NSStatusBarButton) {
        let menu = NSMenu()
        let refresh = NSMenuItem(title: "Refresh Now", action: #selector(refreshNow), keyEquivalent: "r")
        refresh.target = self
        menu.addItem(refresh)
        menu.addItem(.separator())
        let quit = NSMenuItem(title: "Quit UpworkBuddy", action: #selector(quitApp), keyEquivalent: "q")
        quit.target = self
        menu.addItem(quit)
        statusItem.menu = menu
        button.performClick(nil)
        statusItem.menu = nil
    }

    @objc private func refreshNow() {
        Task { await store.refresh(force: true); refreshStatusButton() }
    }

    @objc private func quitApp() {
        NSApp.terminate(nil)
    }

    func popoverShouldDetach(_ popover: NSPopover) -> Bool { false }

    func popoverDidClose(_ notification: Notification) {
        guard pendingStatusRefresh else { return }
        pendingStatusRefresh = false
        refreshStatusButton()
    }

    private func makeMenuBarIcon() -> NSImage? {
        if let url = Bundle.module.url(
            forResource: "MenuBarIconTemplate",
            withExtension: "png",
            subdirectory: "GeneratedBrand"
        ),
           let image = NSImage(contentsOf: url) {
            image.size = NSSize(width: menubarIconPointSize, height: menubarIconPointSize)
            image.isTemplate = true
            image.accessibilityDescription = "UpworkBuddy"
            return image
        }

        let config = NSImage.SymbolConfiguration(pointSize: menubarTitleFontSize, weight: .medium)
        let fallback = NSImage(systemSymbolName: "briefcase.fill", accessibilityDescription: "UpworkBuddy")?
            .withSymbolConfiguration(config)
        fallback?.isTemplate = true
        return fallback
    }
}
