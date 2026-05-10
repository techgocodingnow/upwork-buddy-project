import Foundation
import Sparkle
import UserNotifications
import Observation
import os

private let updateLogger = Logger(subsystem: "com.gocodingnow.UpworkBuddy", category: "Update")

/// Notification category and action identifiers.
enum UpdateNotification {
    static let category = "UPDATE_AVAILABLE"
    static let installAction = "UPDATE_INSTALL"
    static let dismissAction = "UPDATE_DISMISS"
}

/// `@Observable` bridge over Sparkle's `SPUUpdater` so SwiftUI views can read
/// `lastCheckedDate`, `automaticChecksEnabled`, and `canCheckForUpdates`
/// reactively. KVO observers mirror Sparkle state into stored properties.
@MainActor
@Observable
final class UpdateService: NSObject {
    static let shared = UpdateService()

    // Sparkle KVO is mirrored into these @Observable-tracked properties.
    private(set) var canCheckForUpdates: Bool = false
    private(set) var lastCheckedDate: Date?
    private(set) var isCheckingForUpdates: Bool = false

    var automaticChecksEnabled: Bool {
        get { controller.updater.automaticallyChecksForUpdates }
        set {
            controller.updater.automaticallyChecksForUpdates = newValue
            updateLogger.info("automaticallyChecksForUpdates set to \(newValue)")
        }
    }

    @ObservationIgnored
    private var controller: SPUStandardUpdaterController!

    @ObservationIgnored
    private var observers: [NSKeyValueObservation] = []

    override init() {
        super.init()

        // Two-step init: SPUStandardUpdaterController stores its delegate on
        // construction, so we build it AFTER super.init() with self as delegate.
        controller = SPUStandardUpdaterController(
            startingUpdater: false,
            updaterDelegate: self,
            userDriverDelegate: nil
        )

        bindObservers()
        controller.startUpdater()
    }

    private func bindObservers() {
        let updater = controller.updater
        observers.append(updater.observe(\.canCheckForUpdates, options: [.initial, .new]) { [weak self] _, change in
            guard let self else { return }
            let value = change.newValue ?? false
            Task { @MainActor in self.canCheckForUpdates = value }
        })
        observers.append(updater.observe(\.lastUpdateCheckDate, options: [.initial, .new]) { [weak self] _, change in
            guard let self else { return }
            let value = change.newValue ?? nil
            Task { @MainActor in self.lastCheckedDate = value }
        })
        observers.append(updater.observe(\.sessionInProgress, options: [.initial, .new]) { [weak self] _, change in
            guard let self else { return }
            let value = change.newValue ?? false
            Task { @MainActor in self.isCheckingForUpdates = value }
        })
    }

    /// User-facing "Check for Updates" — surfaces Sparkle's standard window if
    /// an update is available, or a "you're up to date" alert otherwise.
    func checkForUpdates() {
        controller.checkForUpdates(nil)
    }

    /// Registers the `UPDATE_AVAILABLE` notification category with an Install
    /// action button. Call once at launch after notification authorization.
    static func registerNotificationCategory() {
        let install = UNNotificationAction(
            identifier: UpdateNotification.installAction,
            title: "Install",
            options: [.foreground]
        )
        let dismiss = UNNotificationAction(
            identifier: UpdateNotification.dismissAction,
            title: "Dismiss",
            options: []
        )
        let category = UNNotificationCategory(
            identifier: UpdateNotification.category,
            actions: [install, dismiss],
            intentIdentifiers: [],
            options: []
        )
        UNUserNotificationCenter.current().setNotificationCategories([category])
    }
}

// MARK: - SPUUpdaterDelegate

extension UpdateService: SPUUpdaterDelegate {
    nonisolated func updater(_ updater: SPUUpdater, didFindValidUpdate item: SUAppcastItem) {
        let version = item.displayVersionString
        updateLogger.info("Sparkle found update: \(version, privacy: .public)")
        Task { @MainActor in
            await self.fireUpdateNotification(version: version)
        }
    }

    nonisolated func updaterDidNotFindUpdate(_ updater: SPUUpdater) {
        updateLogger.debug("Sparkle: no update available")
    }

    @MainActor
    private func fireUpdateNotification(version: String) async {
        let center = UNUserNotificationCenter.current()
        let settings = await center.notificationSettings()
        guard settings.authorizationStatus == .authorized || settings.authorizationStatus == .provisional else {
            updateLogger.info("Skipping update notification — authorization not granted")
            return
        }

        let content = UNMutableNotificationContent()
        content.title = "UpworkBuddy update available"
        content.body = "Version \(version) is ready to install."
        content.categoryIdentifier = UpdateNotification.category
        content.sound = .default

        let request = UNNotificationRequest(
            identifier: "update-\(version)",
            content: content,
            trigger: nil
        )
        do {
            try await center.add(request)
        } catch {
            updateLogger.error("Failed to post update notification: \(error.localizedDescription, privacy: .public)")
        }
    }
}
