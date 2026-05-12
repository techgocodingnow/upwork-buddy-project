import SwiftUI
import AppKit

private let aboutAuthorURL   = URL(string: "https://github.com/anthropics")!

/// Inline About page rendered inside `SettingsContent`. Inherits the
/// active theme background from the parent container.
struct AboutPage: View {
    @State private var showingResetConfirm = false
    @Environment(AppStore.self) private var store

    var body: some View {
        VStack(spacing: 26) {
            heroBlock
            Divider().background(Theme.divider)
            createdByBlock
            linksBlock
            Spacer(minLength: 12)
            footerBlock
        }
        .frame(maxWidth: .infinity)
        .alert(L10n.t("Reset App Data?"), isPresented: $showingResetConfirm) {
            Button(L10n.t("Cancel"), role: .cancel) {}
            Button(L10n.t("Reset"), role: .destructive) {
                Task { await performReset() }
            }
        } message: {
            Text(loc: "Signs you out, clears cached earnings, and resets all preferences on this Mac. The action cannot be undone.")
        }
    }

    // MARK: - Hero

    private var heroBlock: some View {
        VStack(spacing: 12) {
            appIcon
                .frame(width: 96, height: 96)

            Text(appName)
                .font(Theme.body(size: 24, weight: .bold))
                .foregroundStyle(Theme.textPrimary)

            Text(L10n.t("Version %@", appVersion))
                .font(Theme.body(size: 13))
                .foregroundStyle(Theme.textTertiary)

            Button {
                UpdateService.shared.checkForUpdates()
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "arrow.down.circle")
                        .font(Theme.body(size: 13, weight: .semibold))
                    Text(loc: "Check for Updates")
                        .font(Theme.body(size: 13, weight: .semibold))
                }
                .foregroundStyle(Theme.accentDeep)
            }
            .buttonStyle(.plain)
            .accessibilityLabel(L10n.t("Check for Updates"))
        }
    }

    private var appIcon: some View {
        Group {
            if let url = Bundle.module.url(
                forResource: "UpworkBuddyAppLogo",
                withExtension: "png",
                subdirectory: "GeneratedBrand"
            ),
               let nsImage = NSImage(contentsOf: url) {
                Image(nsImage: nsImage)
                    .resizable()
                    .interpolation(.high)
                    .scaledToFit()
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: Theme.radius(22), style: .continuous)
                        .fill(Theme.accentDeep)
                    Image(systemName: "briefcase.fill")
                        .font(Theme.body(size: 40, weight: .bold))
                        .foregroundStyle(Theme.onAccent)
                }
                .accessibilityHidden(true)
            }
        }
    }

    // MARK: - Created by

    private var createdByBlock: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(loc: "Created By")
                .font(Theme.body(size: 14.5, weight: .semibold))
                .foregroundStyle(Theme.textPrimary)

            Button {
                NSWorkspace.shared.open(aboutAuthorURL)
            } label: {
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Theme.chipBg)
                        Image(systemName: "person.fill")
                            .font(Theme.body(size: 16, weight: .semibold))
                            .foregroundStyle(Theme.textSecondary)
                    }
                    .frame(width: 38, height: 38)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(authorName)
                            .font(Theme.body(size: 13.5, weight: .semibold))
                            .foregroundStyle(Theme.textPrimary)
                        Text(authorHandle)
                            .font(Theme.body(size: 11.5))
                            .foregroundStyle(Theme.textTertiary)
                    }
                    Spacer(minLength: 8)
                    Image(systemName: "arrow.up.right")
                        .font(Theme.body(size: 11, weight: .semibold))
                        .foregroundStyle(Theme.textTertiary)
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Theme.surface.opacity(0.6))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .strokeBorder(Theme.divider, lineWidth: 0.6)
                )
            }
            .buttonStyle(.plain)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Links

    private var linksBlock: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(loc: "Links")
                .font(Theme.body(size: 14.5, weight: .semibold))
                .foregroundStyle(Theme.textPrimary)

            VStack(spacing: 0) {
                AboutLinkRow(
                    icon: "bubble.left.and.bubble.right.fill",
                    label: L10n.t("Send Feedback"),
                    trailing: .arrow
                ) {
                    FeedbackWindow.show(store: store)
                }
                Divider().background(Theme.divider)
                AboutLinkRow(
                    icon: "trash.fill",
                    label: L10n.t("Reset App Data"),
                    trailing: .arrow,
                    destructive: true
                ) {
                    showingResetConfirm = true
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Theme.surface.opacity(0.6))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .strokeBorder(Theme.divider, lineWidth: 0.6)
            )
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Footer

    private var footerBlock: some View {
        VStack(spacing: 4) {
            Text(loc: "MIT License • Open Source")
                .font(Theme.body(size: 11.5))
                .foregroundStyle(Theme.textTertiary)
            Text(verbatim: "© \(currentYear) \(authorName)")
                .font(Theme.body(size: 11.5))
                .foregroundStyle(Theme.textTertiary)
        }
        .padding(.top, 16)
    }

    // MARK: - Helpers

    private var appName: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
            ?? Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String
            ?? "UpworkBuddy"
    }

    private var appVersion: String {
        let short = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "0.0.0"
        let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "0"
        return "\(short) (\(build))"
    }

    private var authorName: String   { "Kevin" }
    private var authorHandle: String { "@gocodingnow" }
    private var currentYear: String  {
        let f = DateFormatter()
        f.dateFormat = "yyyy"
        return f.string(from: Date())
    }

    private func performReset() async {
        await store.logout()
        let domain = Bundle.main.bundleIdentifier ?? "com.gocodingnow.UpworkBuddy"
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
    }
}

private struct AboutLinkRow: View {
    enum Trailing { case external, arrow, none }

    let icon: String
    let label: String
    let trailing: Trailing
    var destructive: Bool = false
    let action: () -> Void

    @State private var hovering = false
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        let destructiveColor = SeverityColor.critical(colorScheme)
        Button(action: action) {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(Theme.body(size: 14, weight: .semibold))
                    .foregroundStyle(destructive ? destructiveColor : Theme.textPrimary)
                    .frame(width: 22)
                Text(label)
                    .font(Theme.body(size: 13, weight: .medium))
                    .foregroundStyle(destructive ? destructiveColor : Theme.textPrimary)
                Spacer(minLength: 8)
                trailingGlyph
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 13)
            .background(hovering ? Theme.accent.opacity(0.08) : .clear)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .onHover { hovering = $0 }
    }

    @ViewBuilder
    private var trailingGlyph: some View {
        switch trailing {
        case .external:
            Image(systemName: "arrow.up.right")
                .font(Theme.body(size: 11, weight: .semibold))
                .foregroundStyle(Theme.textTertiary)
        case .arrow:
            Image(systemName: "chevron.right")
                .font(Theme.body(size: 11, weight: .semibold))
                .foregroundStyle(Theme.textTertiary)
        case .none:
            EmptyView()
        }
    }
}
