import SwiftUI
import AppKit

/// "Help Us Improve" feedback form. Submit composes a mailto: URL — the user's
/// default mail client opens with the body prefilled. No network, no backend,
/// no analytics; the message goes through whatever email account the user
/// already trusts.
struct FeedbackView: View {
    @Environment(AppStore.self) private var store
    var onClose: (() -> Void)? = nil

    private func dismiss() {
        if let onClose {
            onClose()
        } else {
            NSApp.keyWindow?.close()
        }
    }

    @State private var name = ""
    @State private var role: FeedbackRole = .developer
    @State private var email = ""
    @State private var message = ""
    @State private var submitting = false

    var body: some View {
        ThemedRoot(store: store) {
            form
        }
    }

    private var form: some View {
        VStack(alignment: .leading, spacing: 18) {
            header
            field(placeholder: L10n.t("Name"), text: $name)
            roleField
            field(placeholder: L10n.t("Email"), text: $email, keyboard: .emailAddress)
            messageField
            actionRow
            dontAskRow
        }
        .padding(20)
        .frame(width: 480)
        .background(Theme.bgGradient)
        .background(
            RoundedRectangle(cornerRadius: Theme.radius(16), style: .continuous)
                .fill(Theme.surface)
        )
        .overlay(
            RoundedRectangle(cornerRadius: Theme.radius(16), style: .continuous)
                .strokeBorder(Theme.divider, lineWidth: 0.6)
        )
    }

    // MARK: - Header

    private var header: some View {
        HStack(alignment: .top, spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: Theme.radius(10), style: .continuous)
                    .fill(Theme.accentMuted)
                Image(systemName: "bubble.left.and.bubble.right.fill")
                    .font(Theme.body(size: 22, weight: .semibold))
                    .foregroundStyle(Theme.accentDeep)
            }
            .frame(width: 50, height: 50)
            .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 4) {
                Text(loc: "Help Us Improve")
                    .font(Theme.body(size: 16, weight: .bold))
                    .foregroundStyle(Theme.textPrimary)
                    .accessibilityAddTraits(.isHeader)
                Text(loc: "Your feedback shapes the future of this app")
                    .font(Theme.body(size: 12.5))
                    .foregroundStyle(Theme.textSecondary)
            }
            Spacer(minLength: 0)
        }
    }

    // MARK: - Fields

    private func field(placeholder: String,
                       text: Binding<String>,
                       keyboard: PlatformKeyboard = .default) -> some View {
        TextField("", text: text, prompt: Text(placeholder)
            .foregroundStyle(Theme.textSecondary)
        )
            .textFieldStyle(.plain)
            .font(Theme.body(size: 13))
            .foregroundStyle(Theme.textPrimary)
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: Theme.radius(10), style: .continuous)
                    .fill(Theme.chipBg.opacity(0.55))
            )
            .overlay(
                RoundedRectangle(cornerRadius: Theme.radius(10), style: .continuous)
                    .strokeBorder(Theme.divider, lineWidth: 0.6)
            )
            .accessibilityLabel(placeholder)
    }

    private var roleField: some View {
        HStack {
            Text(loc: "Role")
                .font(Theme.body(size: 13))
                .foregroundStyle(Theme.textSecondary)
            Spacer()
            Picker("", selection: $role) {
                ForEach(FeedbackRole.allCases) { option in
                    Text(option.label).tag(option)
                }
            }
            .pickerStyle(.menu)
            .labelsHidden()
            .tint(Theme.accent)
            .frame(maxWidth: 220)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: Theme.radius(10), style: .continuous)
                .fill(Theme.chipBg.opacity(0.55))
        )
        .overlay(
            RoundedRectangle(cornerRadius: Theme.radius(10), style: .continuous)
                .strokeBorder(Theme.divider, lineWidth: 0.6)
        )
    }

    private var messageField: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: Theme.radius(10), style: .continuous)
                .fill(Theme.chipBg.opacity(0.55))
            RoundedRectangle(cornerRadius: Theme.radius(10), style: .continuous)
                .strokeBorder(Theme.divider, lineWidth: 0.6)

            if message.isEmpty {
                Text(loc: "Tell us anything — feedback, ideas, feature requests…")
                    .font(Theme.body(size: 13))
                    .foregroundStyle(Theme.textSecondary)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 12)
                    .allowsHitTesting(false)
                    .accessibilityHidden(true)
            }

            TextEditor(text: $message)
                .font(Theme.body(size: 13))
                .foregroundStyle(Theme.textPrimary)
                .scrollContentBackground(.hidden)
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .accessibilityLabel(L10n.t("Message"))
        }
        .frame(height: 120)
    }

    // MARK: - Actions

    private var actionRow: some View {
        HStack(spacing: 12) {
            Button {
                FeedbackPrefs.snoozeForDays(7)
                dismiss()
            } label: {
                Text(loc: "Remind Me Later")
                    .font(Theme.body(size: 13, weight: .semibold))
                    .foregroundStyle(Theme.textPrimary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 11)
                    .background(
                        RoundedRectangle(cornerRadius: Theme.radius(10), style: .continuous)
                            .fill(Theme.chipBg.opacity(0.75))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: Theme.radius(10), style: .continuous)
                            .strokeBorder(Theme.divider, lineWidth: 0.6)
                    )
            }
            .buttonStyle(.plain)

            Button(action: submit) {
                HStack(spacing: 8) {
                    Image(systemName: "paperplane.fill")
                        .font(Theme.body(size: 13, weight: .semibold))
                    Text(loc: "Submit")
                        .font(Theme.body(size: 13, weight: .semibold))
                }
                .foregroundStyle(canSubmit ? Theme.onAccent : Theme.onAccent.opacity(0.65))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 11)
                .background(
                    RoundedRectangle(cornerRadius: Theme.radius(10), style: .continuous)
                        .fill(Theme.accentDeep
                            .opacity(canSubmit ? 1 : 0.55))
                )
            }
            .buttonStyle(.plain)
            .disabled(!canSubmit || submitting)
        }
    }

    private var dontAskRow: some View {
        HStack {
            Spacer()
            Button {
                FeedbackPrefs.disablePrompt()
                dismiss()
            } label: {
                Text(loc: "Don't Ask Again")
                    .font(Theme.body(size: 12, weight: .medium))
                    .foregroundStyle(Theme.textSecondary)
                    .underline()
            }
            .buttonStyle(.plain)
            Spacer()
        }
    }

    // MARK: - Submission

    private var canSubmit: Bool {
        !message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private func submit() {
        guard canSubmit else { return }
        submitting = true

        let to = "dev@gocodingnow.click"
        let subject = L10n.t("UpworkBuddy Feedback — %@", role.label)
        let bodyLines = [
            "Name: \(name.isEmpty ? "(unspecified)" : name)",
            "Role: \(role.label)",
            "Email: \(email.isEmpty ? "(unspecified)" : email)",
            "",
            "---",
            "",
            message
        ]
        let body = bodyLines.joined(separator: "\n")

        var components = URLComponents()
        components.scheme = "mailto"
        components.path = to
        components.queryItems = [
            URLQueryItem(name: "subject", value: subject),
            URLQueryItem(name: "body", value: body)
        ]

        if let url = components.url {
            NSWorkspace.shared.open(url)
        }

        FeedbackPrefs.markSubmitted()
        submitting = false
        dismiss()
    }
}

// MARK: - Role enum

enum FeedbackRole: String, CaseIterable, Identifiable, Sendable {
    case developer
    case designer
    case manager
    case student
    case researcher
    case other

    var id: String { rawValue }

    var label: String {
        switch self {
        case .developer:  return L10n.t("Developer")
        case .designer:   return L10n.t("Designer")
        case .manager:    return L10n.t("Manager")
        case .student:    return L10n.t("Student")
        case .researcher: return L10n.t("Researcher")
        case .other:      return L10n.t("Other")
        }
    }
}

private enum PlatformKeyboard {
    case `default`
    case emailAddress
}

// MARK: - Persistence

/// Lightweight UserDefaults-backed prefs for the feedback prompt. Keeps the
/// dialog reusable from "Send Feedback" today and from a future auto-prompt
/// without needing to thread state through AppStore.
enum FeedbackPrefs {
    private static let kSubmitted     = "UpworkBuddyFeedbackSubmitted"
    private static let kSnoozeUntil   = "UpworkBuddyFeedbackSnoozeUntil"
    private static let kPromptDisabled = "UpworkBuddyFeedbackPromptDisabled"

    static var hasSubmitted: Bool {
        UserDefaults.standard.bool(forKey: kSubmitted)
    }

    static var promptDisabled: Bool {
        UserDefaults.standard.bool(forKey: kPromptDisabled)
    }

    static var snoozedUntil: Date? {
        let ts = UserDefaults.standard.double(forKey: kSnoozeUntil)
        guard ts > 0 else { return nil }
        return Date(timeIntervalSince1970: ts)
    }

    /// Returns true when an auto-prompt is currently allowed. Manual entry from
    /// "Send Feedback" should bypass this check.
    static var shouldAutoPrompt: Bool {
        if hasSubmitted { return false }
        if promptDisabled { return false }
        if let until = snoozedUntil, Date() < until { return false }
        return true
    }

    static func markSubmitted() {
        UserDefaults.standard.set(true, forKey: kSubmitted)
    }

    static func snoozeForDays(_ days: Int) {
        let until = Date().addingTimeInterval(TimeInterval(days) * 86_400)
        UserDefaults.standard.set(until.timeIntervalSince1970, forKey: kSnoozeUntil)
    }

    static func disablePrompt() {
        UserDefaults.standard.set(true, forKey: kPromptDisabled)
    }
}

// MARK: - Window host

@MainActor
enum FeedbackWindow {
    private static var window: NSWindow?
    private static var observationToken: Any?

    static func show(store: AppStore) {
        if let existing = window {
            applyAppearance(existing, store: store)
            existing.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
            return
        }

        let view = FeedbackView(onClose: { close() })
            .environment(store)
        let hosting = NSHostingController(rootView: view)
        let win = NSWindow(contentViewController: hosting)
        win.setContentSize(NSSize(width: 520, height: 560))
        win.styleMask = [.titled, .closable, .fullSizeContentView]
        win.titlebarAppearsTransparent = true
        win.titleVisibility = .hidden
        win.isReleasedWhenClosed = false
        win.center()
        win.delegate = FeedbackWindowDelegate.shared

        applyAppearance(win, store: store)
        observeAppearance(window: win, store: store)

        window = win
        NSApp.activate(ignoringOtherApps: true)
        win.makeKeyAndOrderFront(nil)
    }

    static func didClose() {
        window = nil
    }

    static func close() {
        window?.close()
        window = nil
    }

    private static func applyAppearance(_ win: NSWindow, store: AppStore) {
        win.appearance = nsAppearance(for: store.appAppearance)
    }

    private static func observeAppearance(window win: NSWindow, store: AppStore) {
        withObservationTracking {
            _ = store.appAppearance
        } onChange: {
            DispatchQueue.main.async {
                guard let current = window else { return }
                applyAppearance(current, store: store)
                observeAppearance(window: current, store: store)
            }
        }
    }
}

@MainActor
private final class FeedbackWindowDelegate: NSObject, NSWindowDelegate {
    static let shared = FeedbackWindowDelegate()
    func windowWillClose(_ notification: Notification) {
        FeedbackWindow.didClose()
    }
}

/// Maps the user's appearance override to an `NSAppearance` for `NSWindow.appearance`.
/// `.system` returns nil so AppKit follows macOS.
@MainActor
func nsAppearance(for appearance: AppAppearance) -> NSAppearance? {
    switch appearance {
    case .system: return nil
    case .light:  return NSAppearance(named: .aqua)
    case .dark:   return NSAppearance(named: .darkAqua)
    }
}
