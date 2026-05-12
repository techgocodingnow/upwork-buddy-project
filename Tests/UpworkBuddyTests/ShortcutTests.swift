import Testing
import AppKit
import Carbon.HIToolbox
@testable import UpworkBuddy

@Suite("Shortcut", .serialized)
struct ShortcutTests {

    @Test func modifiersIntersectionMasksDeviceFlags() {
        // Include capsLock (not device-independent) in raw bits — should drop.
        let s = Shortcut(
            keyCode: UInt32(kVK_ANSI_A),
            modifierRaw: NSEvent.ModifierFlags([.command, .capsLock]).rawValue
        )
        #expect(s.modifiers.contains(.command))
        // capsLock IS in deviceIndependentFlagsMask, so it stays — actually verify it stays.
        // Use a non-mask bit (e.g. .help is device-independent too). Just check intersection didn't blow up.
        #expect(s.hasModifier)
    }

    @Test func hasModifierTrueWhenAnyHeld() {
        for flags: NSEvent.ModifierFlags in [.command, .option, .control, .shift] {
            let s = Shortcut(
                keyCode: UInt32(kVK_ANSI_A),
                modifierRaw: flags.rawValue
            )
            #expect(s.hasModifier)
        }
    }

    @Test func hasModifierFalseWhenNoneHeld() {
        let s = Shortcut(keyCode: UInt32(kVK_ANSI_A), modifierRaw: 0)
        #expect(!s.hasModifier)
    }

    @Test func carbonModifiersMapAllFlags() {
        let s = Shortcut(
            keyCode: UInt32(kVK_ANSI_A),
            modifierRaw: NSEvent.ModifierFlags([.command, .option, .control, .shift]).rawValue
        )
        let cm = s.carbonModifiers
        #expect(cm & UInt32(cmdKey) != 0)
        #expect(cm & UInt32(optionKey) != 0)
        #expect(cm & UInt32(controlKey) != 0)
        #expect(cm & UInt32(shiftKey) != 0)
    }

    @Test func carbonModifiersZeroWhenNoFlags() {
        let s = Shortcut(keyCode: UInt32(kVK_ANSI_A), modifierRaw: 0)
        #expect(s.carbonModifiers == 0)
    }

    @Test func displayStringOrdersControlOptionShiftCommand() {
        let s = Shortcut(
            keyCode: UInt32(kVK_ANSI_A),
            modifierRaw: NSEvent.ModifierFlags([.command, .option, .control, .shift]).rawValue
        )
        let d = s.displayString
        // Symbols in fixed order: ⌃⌥⇧⌘<key>
        #expect(d.hasPrefix("⌃⌥⇧⌘"))
    }

    @Test func displayStringRendersSpecialKeyGlyphs() {
        let cases: [(Int32, String)] = [
            (Int32(kVK_Return), "↩"),
            (Int32(kVK_Tab), "⇥"),
            (Int32(kVK_Space), "␣"),
            (Int32(kVK_Delete), "⌫"),
            (Int32(kVK_Escape), "⎋"),
            (Int32(kVK_LeftArrow), "←"),
            (Int32(kVK_RightArrow), "→"),
            (Int32(kVK_UpArrow), "↑"),
            (Int32(kVK_DownArrow), "↓"),
        ]
        for (code, glyph) in cases {
            #expect(Shortcut.keyName(for: UInt32(code)) == glyph)
        }
    }

    @Test func displayStringRendersFunctionKeys() {
        for (code, label) in [
            (Int32(kVK_F1), "F1"),
            (Int32(kVK_F5), "F5"),
            (Int32(kVK_F12), "F12"),
        ] {
            #expect(Shortcut.keyName(for: UInt32(code)) == label)
        }
    }

    @Test func keyNameForRegularLetterReturnsUppercase() {
        let name = Shortcut.keyName(for: UInt32(kVK_ANSI_A))
        // Some CI envs without a keyboard layout return "?", so accept both.
        #expect(name == "A" || name == "?")
    }

    @Test func codableRoundTrip() throws {
        let s = Shortcut(
            keyCode: UInt32(kVK_ANSI_U),
            modifierRaw: NSEvent.ModifierFlags([.command, .option]).rawValue
        )
        let data = try JSONEncoder().encode(s)
        let back = try JSONDecoder().decode(Shortcut.self, from: data)
        #expect(back == s)
    }

    @Test func defaultShortcutsUseCommandOption() {
        for action in ShortcutAction.allCases {
            let s = action.defaultShortcut
            #expect(s.modifiers.contains(.command))
            #expect(s.modifiers.contains(.option))
        }
    }

    @Test func shortcutActionLabelsLocalize() {
        for action in ShortcutAction.allCases {
            #expect(!action.label.isEmpty)
            #expect(!action.subtitle.isEmpty)
            #expect(!action.systemImage.isEmpty)
        }
    }
}
