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
    private var outsideClickMonitor: Any?

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
                        self.startOutsideClickMonitor()
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
        registerGlobalHotkey()

        Task { await store.bootstrap() }
        Task { await GoalNotificationService.shared.requestAuthorizationIfNeeded() }
    }

    func applicationDidBecomeActive(_ notification: Notification) {
        store.reconcileLaunchAtLogin()
    }

    func applicationWillTerminate(_ notification: Notification) {
        HotkeyManager.shared.unbindAll()
    }

    private func registerGlobalHotkey() {
        rebindAllHotkeys()
        observeShortcutChanges()
    }

    private func rebindAllHotkeys() {
        for action in ShortcutAction.allCases {
            let shortcut = store.shortcuts[action] ?? nil
            HotkeyManager.shared.bind(action, to: shortcut) { [weak self] in
                self?.handleShortcut(action)
            }
        }
    }

    private func observeShortcutChanges() {
        withObservationTracking {
            _ = store.shortcuts
        } onChange: { [weak self] in
            DispatchQueue.main.async {
                self?.rebindAllHotkeys()
                self?.observeShortcutChanges()
            }
        }
    }

    private func handleShortcut(_ action: ShortcutAction) {
        switch action {
        case .togglePopover:
            guard let button = statusItem.button else { return }
            handleButtonClick(button)
        case .refreshNow:
            Task { await store.refresh(force: true); refreshStatusButton() }
        case .openSettings:
            SettingsWindow.show(store: store)
        }
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
            _ = store.weekSnapshot
            _ = store.snapshot
            _ = store.isAuthenticated
            _ = store.hideSensitive
            _ = store.menuBarMetric
            _ = store.menuBarIconStyle
            _ = store.todayMetricEnabled
            _ = store.todayMetricStyle
            _ = store.weekMetricEnabled
            _ = store.weekMetricStyle
            _ = store.weekMetricMode
            _ = store.goalsEnabled
            _ = store.goalHoursDaily
            _ = store.goalHoursWeekly
            _ = store.goalEarningsDaily
            _ = store.goalEarningsWeekly
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

        button.image = nil
        button.imagePosition = .noImage

        // Logged out → just the briefcase glyph (clickable affordance).
        guard store.isAuthenticated else {
            let attachment = NSTextAttachment()
            attachment.image = makeMenuBarIcon()
            if let size = attachment.image?.size {
                attachment.bounds = CGRect(x: 0, y: -3, width: size.width, height: size.height)
            }
            button.attributedTitle = NSAttributedString(attachment: attachment)
            return
        }

        let composed = NSMutableAttributedString()
        var appended = 0

        if store.todayMetricEnabled {
            if let attr = makeMetricAttachment(
                snapshot: store.todaySnapshot,
                period: .today,
                style: store.todayMetricStyle,
                mode: .percentage,                 // today has no display-mode toggle
                periodCaption: "Today"
            ) {
                composed.append(attr)
                appended += 1
            }
        }

        if store.weekMetricEnabled {
            if appended > 0 {
                composed.append(NSAttributedString(string: "  "))
            }
            if let attr = makeMetricAttachment(
                snapshot: store.weekSnapshot,
                period: .week,
                style: store.weekMetricStyle,
                mode: store.weekMetricMode,
                periodCaption: "Week"
            ) {
                composed.append(attr)
                appended += 1
            }
        }

        // Nothing enabled — fall back to the brand glyph so the menu item is
        // still discoverable / clickable.
        if appended == 0 {
            let attachment = NSTextAttachment()
            attachment.image = makeMenuBarIcon()
            if let size = attachment.image?.size {
                attachment.bounds = CGRect(x: 0, y: -3, width: size.width, height: size.height)
            }
            composed.append(NSAttributedString(attachment: attachment))
        }

        button.attributedTitle = composed
    }

    /// Renders one metric (style + label) into an NSAttributedString attachment
    /// suitable for the status item title.
    private func makeMetricAttachment(snapshot: EarningsSnapshot,
                                      period: Period,
                                      style: MenuBarMetricStyle,
                                      mode: MenuBarDisplayMode,
                                      periodCaption: String) -> NSAttributedString? {
        let progress = MenuBarMetricFormatter.progress(snapshot: snapshot, period: period, store: store)
        let label: String = {
            switch style {
            case .batteryClassic: return periodCaption
            case .progressBar, .compact: return ""
            case .percentage, .iconWithBar:
                return MenuBarMetricFormatter.label(
                    snapshot: snapshot, period: period, store: store, mode: mode
                )
            }
        }()

        let preview = MenuBarStylePreview(
            style: style,
            progress: progress,
            label: label,
            width: previewWidth(for: style),
            height: 18
        )

        let renderer = ImageRenderer(content: preview)
        renderer.scale = NSScreen.main?.backingScaleFactor ?? 2
        guard let nsImage = renderer.nsImage else { return nil }
        nsImage.isTemplate = false   // styles use color (accent) — not template glyphs.

        let attachment = NSTextAttachment()
        attachment.image = nsImage
        attachment.bounds = CGRect(x: 0, y: -4, width: nsImage.size.width, height: nsImage.size.height)
        return NSAttributedString(attachment: attachment)
    }

    private func previewWidth(for style: MenuBarMetricStyle) -> CGFloat {
        switch style {
        case .batteryClassic: return 56
        case .progressBar:    return 44
        case .percentage:     return 38
        case .iconWithBar:    return 18
        case .compact:        return 12
        }
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
            startOutsideClickMonitor()
        }
    }

    private func startOutsideClickMonitor() {
        stopOutsideClickMonitor()
        outsideClickMonitor = NSEvent.addGlobalMonitorForEvents(
            matching: [.leftMouseDown, .rightMouseDown]
        ) { [weak self] _ in
            guard let self, self.popover.isShown else { return }
            self.popover.performClose(nil)
        }
    }

    private func stopOutsideClickMonitor() {
        if let monitor = outsideClickMonitor {
            NSEvent.removeMonitor(monitor)
            outsideClickMonitor = nil
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
        stopOutsideClickMonitor()
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
