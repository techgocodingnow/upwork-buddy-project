import Foundation
import SwiftUI

/// Thin localization façade. Every user-facing string in the app should go
/// through one of these helpers so the entire copy surface lives in
/// Resources/<lang>.lproj/Localizable.strings and can be translated by
/// adding new .lproj folders.
///
/// Strings resolve against `L10n.currentBundle`, which points at a specific
/// `<lang>.lproj` inside `Bundle.module`. Views remount via `.id(store.preferredLanguage)`
/// so a language switch re-binds Text to the new bundle without restart.
enum L10n {
    nonisolated(unsafe) static var currentBundle: Bundle = .module
    nonisolated(unsafe) static var currentLocale: Locale = .current

    static func setLanguage(_ code: String) {
        if let path = Bundle.module.path(forResource: code, ofType: "lproj"),
           let b = Bundle(path: path) {
            currentBundle = b
        } else {
            currentBundle = .module
        }
        currentLocale = Locale(identifier: code)
    }

    static func t(_ key: String, _ args: CVarArg...) -> String {
        let format = NSLocalizedString(key, tableName: nil, bundle: currentBundle, value: key, comment: "")
        if args.isEmpty { return format }
        let bridged: [CVarArg] = args.map { ($0 as? String).map { $0 as NSString } ?? $0 }
        return String(format: format, locale: .current, arguments: bridged)
    }
}

extension Text {
    init(loc key: String) {
        self.init(LocalizedStringKey(key), bundle: L10n.currentBundle)
    }
}

extension LocalizedStringKey {
    /// Convenience for `LocalizedStringKey` literals when a SwiftUI control
    /// (e.g. `Button(_:)`, `Toggle(_:)`) accepts a key.
    static func loc(_ key: String) -> LocalizedStringKey { LocalizedStringKey(key) }
}
