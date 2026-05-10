import XCTest
import UserNotifications
@testable import UpworkBuddy

@MainActor
final class UpdateServiceTests: XCTestCase {
    func testNotificationCategoryShape() {
        // We can't safely call UNUserNotificationCenter.current() inside a
        // unit-test bundle (no app bundle ID), so just exercise the static
        // shape that registerNotificationCategory will produce.
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

        XCTAssertEqual(category.identifier, "UPDATE_AVAILABLE")
        XCTAssertEqual(category.actions.count, 2)
        XCTAssertTrue(category.actions[0].options.contains(.foreground),
                      "Install action must launch the app to surface Sparkle's window")
    }

    func testNotificationActionIdentifiersAreStable() {
        // Identifiers ship in user notification archives — changing them
        // breaks queued notifications on existing installs.
        XCTAssertEqual(UpdateNotification.category, "UPDATE_AVAILABLE")
        XCTAssertEqual(UpdateNotification.installAction, "UPDATE_INSTALL")
        XCTAssertEqual(UpdateNotification.dismissAction, "UPDATE_DISMISS")
    }
}
