import AppKit
import Carbon.HIToolbox

/// Cocoa modifier flags packed into a stable, persistable bitfield.
/// Stored as the raw NSEvent.ModifierFlags rawValue (UInt) so we can persist
/// without binding to Carbon constants.
struct Shortcut: Codable, Hashable, Sendable {
    /// Carbon virtual keycode (e.g. kVK_ANSI_U == 32).
    let keyCode: UInt32
    /// NSEvent.ModifierFlags rawValue masked to device-independent bits.
    let modifierRaw: UInt

    var modifiers: NSEvent.ModifierFlags {
        NSEvent.ModifierFlags(rawValue: modifierRaw)
            .intersection(.deviceIndependentFlagsMask)
    }

    /// True when at least one of cmd / option / control / shift is held.
    var hasModifier: Bool {
        let m = modifiers
        return m.contains(.command) || m.contains(.option)
            || m.contains(.control) || m.contains(.shift)
    }

    /// Carbon-compatible modifier mask used by RegisterEventHotKey.
    var carbonModifiers: UInt32 {
        var mask: UInt32 = 0
        let m = modifiers
        if m.contains(.command) { mask |= UInt32(cmdKey) }
        if m.contains(.option)  { mask |= UInt32(optionKey) }
        if m.contains(.control) { mask |= UInt32(controlKey) }
        if m.contains(.shift)   { mask |= UInt32(shiftKey) }
        return mask
    }

    var displayString: String {
        var parts: [String] = []
        let m = modifiers
        if m.contains(.control) { parts.append("⌃") }
        if m.contains(.option)  { parts.append("⌥") }
        if m.contains(.shift)   { parts.append("⇧") }
        if m.contains(.command) { parts.append("⌘") }
        parts.append(Self.keyName(for: keyCode))
        return parts.joined()
    }

    static func keyName(for code: UInt32) -> String {
        if let special = Self.specialKeyNames[Int(code)] { return special }
        return Self.character(for: code)?.uppercased() ?? "?"
    }

    private static let specialKeyNames: [Int: String] = [
        kVK_Return: "↩", kVK_Tab: "⇥", kVK_Space: "␣", kVK_Delete: "⌫",
        kVK_Escape: "⎋", kVK_LeftArrow: "←", kVK_RightArrow: "→",
        kVK_UpArrow: "↑", kVK_DownArrow: "↓",
        kVK_F1: "F1", kVK_F2: "F2", kVK_F3: "F3", kVK_F4: "F4",
        kVK_F5: "F5", kVK_F6: "F6", kVK_F7: "F7", kVK_F8: "F8",
        kVK_F9: "F9", kVK_F10: "F10", kVK_F11: "F11", kVK_F12: "F12",
    ]

    /// Best-effort key-code → printable character via current keyboard layout.
    private static func character(for keyCode: UInt32) -> String? {
        guard let source = TISCopyCurrentKeyboardLayoutInputSource()?.takeRetainedValue(),
              let layoutDataPtr = TISGetInputSourceProperty(source, kTISPropertyUnicodeKeyLayoutData)
        else { return nil }
        let layoutData = unsafeBitCast(layoutDataPtr, to: CFData.self) as Data
        return layoutData.withUnsafeBytes { (ptr: UnsafeRawBufferPointer) -> String? in
            guard let base = ptr.baseAddress else { return nil }
            let layout = base.assumingMemoryBound(to: UCKeyboardLayout.self)
            var deadKeyState: UInt32 = 0
            var length = 0
            var chars = [UniChar](repeating: 0, count: 4)
            let status = UCKeyTranslate(
                layout,
                UInt16(keyCode),
                UInt16(kUCKeyActionDisplay),
                0,
                UInt32(LMGetKbdType()),
                OptionBits(kUCKeyTranslateNoDeadKeysBit),
                &deadKeyState,
                chars.count,
                &length,
                &chars
            )
            guard status == noErr, length > 0 else { return nil }
            return String(utf16CodeUnits: chars, count: length)
        }
    }
}

enum ShortcutAction: String, CaseIterable, Codable, Identifiable, Sendable {
    case togglePopover
    case refreshNow
    case openSettings

    var id: String { rawValue }

    var label: String {
        switch self {
        case .togglePopover: return "Toggle Popover"
        case .refreshNow:    return "Refresh Now"
        case .openSettings:  return "Open Settings"
        }
    }

    var subtitle: String {
        switch self {
        case .togglePopover: return "Show or hide the UpworkBuddy popover"
        case .refreshNow:    return "Fetch the latest earnings data"
        case .openSettings:  return "Open the settings window"
        }
    }

    var systemImage: String {
        switch self {
        case .togglePopover: return "rectangle.on.rectangle"
        case .refreshNow:    return "arrow.clockwise"
        case .openSettings:  return "gearshape"
        }
    }

    /// Built-in defaults — overridable per user.
    var defaultShortcut: Shortcut {
        switch self {
        case .togglePopover:
            return Shortcut(
                keyCode: UInt32(kVK_ANSI_U),
                modifierRaw: NSEvent.ModifierFlags([.command, .option]).rawValue
            )
        case .refreshNow:
            return Shortcut(
                keyCode: UInt32(kVK_ANSI_R),
                modifierRaw: NSEvent.ModifierFlags([.command, .option]).rawValue
            )
        case .openSettings:
            return Shortcut(
                keyCode: UInt32(kVK_ANSI_Comma),
                modifierRaw: NSEvent.ModifierFlags([.command, .option]).rawValue
            )
        }
    }
}
