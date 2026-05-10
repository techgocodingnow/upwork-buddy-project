import SwiftUI
import AppKit
import Carbon.HIToolbox

/// Click-to-record shortcut field. While recording, captures the next key event
/// (must include at least one modifier) via a local NSEvent monitor.
struct ShortcutRecorder: View {
    let shortcut: Shortcut?
    let onCapture: (Shortcut) -> Void
    let onClear: () -> Void

    @State private var isRecording = false
    @State private var monitor: Any?
    @State private var hovering = false

    var body: some View {
        HStack(spacing: 6) {
            recorderButton
            if shortcut != nil && !isRecording {
                Button {
                    onClear()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(Theme.textTertiary)
                }
                .buttonStyle(.plain)
                .help(L10n.t("Clear shortcut"))
                .accessibilityLabel(L10n.t("Clear shortcut"))
            }
        }
        .onDisappear { stopRecording() }
    }

    private var recorderButton: some View {
        Button {
            if isRecording { stopRecording() } else { startRecording() }
        } label: {
            HStack(spacing: 4) {
                Text(buttonLabel)
                    .font(.system(size: 12, weight: isRecording ? .semibold : .medium, design: .monospaced))
                    .foregroundStyle(buttonForeground)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .frame(minWidth: 110)
            .background(
                RoundedRectangle(cornerRadius: 7, style: .continuous)
                    .fill(buttonBackground)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 7, style: .continuous)
                    .strokeBorder(isRecording ? Theme.accent : Theme.divider, lineWidth: isRecording ? 1.5 : 0.5)
            )
        }
        .buttonStyle(.plain)
        .onHover { hovering = $0 }
        .accessibilityLabel(recorderAccessibilityLabel)
    }

    private var recorderAccessibilityLabel: String {
        if isRecording { return "Recording shortcut, press keys" }
        if let s = shortcut?.displayString { return "Shortcut: \(s). Click to record new" }
        return "Click to record shortcut"
    }

    private var buttonLabel: String {
        if isRecording { return "Press shortcut…" }
        return shortcut?.displayString ?? "Click to record"
    }

    private var buttonForeground: Color {
        if isRecording { return Theme.accentDeep }
        if shortcut == nil { return Theme.textTertiary }
        return Theme.textPrimary
    }

    private var buttonBackground: Color {
        if isRecording { return Theme.accent.opacity(0.18) }
        if hovering { return Theme.chipBg.opacity(0.9) }
        return Theme.chipBg.opacity(0.5)
    }

    private func startRecording() {
        guard !isRecording else { return }
        isRecording = true
        monitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
            // Escape cancels.
            if event.keyCode == kVK_Escape { stopRecording(); return nil }

            let mods = event.modifierFlags.intersection(.deviceIndependentFlagsMask)
            let captured = Shortcut(keyCode: UInt32(event.keyCode), modifierRaw: mods.rawValue)
            guard captured.hasModifier else { return nil }  // ignore raw key, keep recording
            onCapture(captured)
            stopRecording()
            return nil
        }
    }

    private func stopRecording() {
        if let m = monitor { NSEvent.removeMonitor(m); monitor = nil }
        isRecording = false
    }
}
