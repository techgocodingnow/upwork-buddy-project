import Foundation
import SwiftUI

/// Thin localization façade. Every user-facing string in the app should go
/// through one of these helpers so the entire copy surface lives in
/// Resources/<lang>.lproj/Localizable.strings and can be translated by
/// adding new .lproj folders.
///
/// All strings resolve against `Bundle.module` so they survive being run
/// from a SwiftPM-built bundle.
enum L10n {
    /// Programmatic lookup. Use this when assembling Strings outside SwiftUI
    /// (model layer, services, formatting, accessibility labels coerced to
    /// `String`, alert message bodies, etc.).
    static func t(_ key: String, _ args: CVarArg...) -> String {
        let format = NSLocalizedString(key, tableName: nil, bundle: .module, value: key, comment: "")
        if args.isEmpty { return format }
        // Bridge Swift String args to NSString so %@ format specifiers work.
        let bridged: [CVarArg] = args.map { ($0 as? String).map { $0 as NSString } ?? $0 }
        return String(format: format, locale: .current, arguments: bridged)
    }
}

extension Text {
    /// SwiftUI-native localized text bound to Bundle.module. Prefer this over
    /// `Text("literal")` so strings are guaranteed to be looked up in the
    /// app's catalog rather than the host bundle.
    init(loc key: String) {
        self.init(LocalizedStringKey(key), bundle: .module)
    }
}

extension LocalizedStringKey {
    /// Convenience for `LocalizedStringKey` literals when a SwiftUI control
    /// (e.g. `Button(_:)`, `Toggle(_:)`) accepts a key.
    static func loc(_ key: String) -> LocalizedStringKey { LocalizedStringKey(key) }
}
