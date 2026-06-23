import Testing
import Foundation
@testable import UpworkBuddy

@Suite("L10n", .serialized)
struct L10nTests {

    @Test func returnsLocalizedValueWhenPresent() {
        L10n.setLanguage("de")
        defer { L10n.setLanguage("en") }

        #expect(L10n.t("Settings") == "Einstellungen")
    }

    @Test func fallsBackToEnglishWhenLocaleKeyIsMissing() throws {
        try withIncompleteBundle {
            #expect(L10n.t("Celebration style") == "Celebration style")
        }
    }

    @Test func formatsEnglishFallbackStrings() throws {
        try withIncompleteBundle {
            #expect(L10n.t("%@ remaining", "5m") == "5m remaining")
        }
    }

    @Test func unknownKeyStillReturnsKey() {
        L10n.setLanguage("de")
        defer { L10n.setLanguage("en") }

        #expect(L10n.t("__missing_key__") == "__missing_key__")
    }

    private func withIncompleteBundle(_ body: () throws -> Void) throws {
        let previousBundle = L10n.currentBundle
        let previousLocale = L10n.currentLocale
        let directory = FileManager.default.temporaryDirectory
            .appending(path: "UpworkBuddyL10nTests-\(UUID().uuidString).lproj", directoryHint: .isDirectory)

        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        try "\"Settings\" = \"Test Settings\";\n".write(
            to: directory.appending(path: "Localizable.strings"),
            atomically: true,
            encoding: .utf8
        )

        guard let bundle = Bundle(path: directory.path) else {
            throw L10nTestError.bundleUnavailable
        }

        L10n.currentBundle = bundle
        L10n.currentLocale = Locale(identifier: "de")
        defer {
            L10n.currentBundle = previousBundle
            L10n.currentLocale = previousLocale
            try? FileManager.default.removeItem(at: directory)
        }

        try body()
    }

    private enum L10nTestError: Error {
        case bundleUnavailable
    }
}
