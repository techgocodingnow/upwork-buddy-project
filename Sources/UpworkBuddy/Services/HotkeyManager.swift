import AppKit
import Carbon.HIToolbox

/// Registers system-wide hotkeys via Carbon's EventHotKey API. Carbon is the
/// only reliable way on macOS 14 to receive global key events when the app is
/// `.accessory` and another app is frontmost.
@MainActor
final class HotkeyManager {
    static let shared = HotkeyManager()

    private struct Registration {
        var ref: EventHotKeyRef
        var handler: @MainActor () -> Void
    }

    private let signature: OSType = 0x55427562  // 'UBub'
    private var registrations: [ShortcutAction: Registration] = [:]
    private var eventHandler: EventHandlerRef?

    private init() {}

    /// Replace the binding for a single action. Pass `nil` to unbind.
    func bind(_ action: ShortcutAction, to shortcut: Shortcut?, handler: @escaping @MainActor () -> Void) {
        unbind(action)
        installEventHandlerIfNeeded()

        guard let shortcut, shortcut.hasModifier else { return }

        var ref: EventHotKeyRef?
        let id = EventHotKeyID(signature: signature, id: action.hotKeyID)
        let status = RegisterEventHotKey(
            shortcut.keyCode,
            shortcut.carbonModifiers,
            id,
            GetApplicationEventTarget(),
            0,
            &ref
        )
        guard status == noErr, let ref else {
            Log.app.error("Hotkey register failed for \(action.rawValue, privacy: .public): status=\(status)")
            return
        }
        registrations[action] = Registration(ref: ref, handler: handler)
    }

    func unbind(_ action: ShortcutAction) {
        if let existing = registrations.removeValue(forKey: action) {
            UnregisterEventHotKey(existing.ref)
        }
    }

    func unbindAll() {
        for (_, reg) in registrations {
            UnregisterEventHotKey(reg.ref)
        }
        registrations.removeAll()
        if let handler = eventHandler {
            RemoveEventHandler(handler)
            eventHandler = nil
        }
    }

    private func installEventHandlerIfNeeded() {
        guard eventHandler == nil else { return }
        var spec = EventTypeSpec(
            eventClass: OSType(kEventClassKeyboard),
            eventKind: UInt32(kEventHotKeyPressed)
        )
        let context = Unmanaged.passUnretained(self).toOpaque()
        InstallEventHandler(
            GetApplicationEventTarget(),
            { (_, eventRef, userData) -> OSStatus in
                guard let eventRef, let userData else { return noErr }
                var hkID = EventHotKeyID()
                let status = GetEventParameter(
                    eventRef,
                    EventParamName(kEventParamDirectObject),
                    EventParamType(typeEventHotKeyID),
                    nil,
                    MemoryLayout<EventHotKeyID>.size,
                    nil,
                    &hkID
                )
                guard status == noErr else { return noErr }
                let manager = Unmanaged<HotkeyManager>.fromOpaque(userData).takeUnretainedValue()
                let actionId = hkID.id
                DispatchQueue.main.async {
                    MainActor.assumeIsolated {
                        manager.dispatch(actionId: actionId)
                    }
                }
                return noErr
            },
            1,
            &spec,
            context,
            &eventHandler
        )
    }

    private func dispatch(actionId: UInt32) {
        guard let action = ShortcutAction.allCases.first(where: { $0.hotKeyID == actionId }),
              let reg = registrations[action] else { return }
        reg.handler()
    }
}

private extension ShortcutAction {
    /// Stable per-action numeric ID for Carbon's EventHotKeyID.
    var hotKeyID: UInt32 {
        switch self {
        case .togglePopover: return 1
        case .refreshNow:    return 2
        case .openSettings:  return 3
        }
    }
}
