import SwiftUI
import AppKit

private let aboutAuthorURL   = URL(string: "https://github.com/anthropics")!
private let aboutReleasesURL = URL(string: "https://github.com/anthropics/claude-code/releases")!

struct AboutView: View {
    @State private var showingResetConfirm = false
    @Environment(AppStore.self) private var store

    var body: some View {
        ScrollView {
            VStack(spacing: 26) {
                heroBlock
                Divider().background(Color.white.opacity(0.10))
                createdByBlock
                linksBlock
                Spacer(minLength: 12)
                footerBlock
            }
            .padding(.horizontal, 28)
            .padding(.vertical, 32)
            .frame(maxWidth: .infinity)
        }
        .background(backdrop.ignoresSafeArea())
        .frame(minWidth: 460, minHeight: 580)
        .alert("Reset App Data?", isPresented: $showingResetConfirm) {
            Button("Cancel", role: .cancel) {}
            Button("Reset", role: .destructive) {
                Task { await performReset() }
            }
        } message: {
            Text("Signs you out, clears cached earnings, and resets all preferences on this Mac. The action cannot be undone.")
        }
    }

    // MARK: - Backdrop

    private var backdrop: some View {
        LinearGradient(
            colors: [
                Color(red: 0.04, green: 0.07, blue: 0.16),
                Color(red: 0.02, green: 0.03, blue: 0.06)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    // MARK: - Hero

    private var heroBlock: some View {
        VStack(spacing: 12) {
            appIcon
                .frame(width: 96, height: 96)

            Text(appName)
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(Color.white)

            Text("Version \(appVersion)")
                .font(.system(size: 13))
                .foregroundStyle(Color.white.opacity(0.55))

            Button {
                NSWorkspace.shared.open(aboutReleasesURL)
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "arrow.down.circle")
                        .font(.system(size: 13, weight: .semibold))
                    Text("Check for Updates")
                        .font(.system(size: 13, weight: .semibold))
                }
                .foregroundStyle(Color(red: 0.30, green: 0.66, blue: 1.0))
            }
            .buttonStyle(.plain)
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
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .fill(Color(red: 0.76, green: 0.38, blue: 0.11))
                    Image(systemName: "briefcase.fill")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundStyle(Color.white)
                }
            }
        }
    }

    // MARK: - Created by

    private var createdByBlock: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Created By")
                .font(.system(size: 14.5, weight: .semibold))
                .foregroundStyle(Color.white)

            Button {
                NSWorkspace.shared.open(aboutAuthorURL)
            } label: {
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.10))
                        Image(systemName: "person.fill")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(Color.white.opacity(0.7))
                    }
                    .frame(width: 38, height: 38)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(authorName)
                            .font(.system(size: 13.5, weight: .semibold))
                            .foregroundStyle(Color.white)
                        Text(authorHandle)
                            .font(.system(size: 11.5))
                            .foregroundStyle(Color.white.opacity(0.55))
                    }
                    Spacer(minLength: 8)
                    Image(systemName: "arrow.up.right")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(Color.white.opacity(0.45))
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color.white.opacity(0.05))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .strokeBorder(Color.white.opacity(0.08), lineWidth: 0.6)
                )
            }
            .buttonStyle(.plain)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Links

    private var linksBlock: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Links")
                .font(.system(size: 14.5, weight: .semibold))
                .foregroundStyle(Color.white)

            VStack(spacing: 0) {
                AboutLinkRow(
                    icon: "bubble.left.and.bubble.right.fill",
                    label: "Send Feedback",
                    trailing: .arrow
                ) {
                    FeedbackWindow.show()
                }
                Divider().background(Color.white.opacity(0.06))
                AboutLinkRow(
                    icon: "trash.fill",
                    label: "Reset App Data",
                    trailing: .arrow,
                    destructive: true
                ) {
                    showingResetConfirm = true
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.white.opacity(0.05))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .strokeBorder(Color.white.opacity(0.08), lineWidth: 0.6)
            )
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Footer

    private var footerBlock: some View {
        VStack(spacing: 4) {
            Text("MIT License • Open Source")
                .font(.system(size: 11.5))
                .foregroundStyle(Color.white.opacity(0.45))
            Text("© \(currentYear) \(authorName)")
                .font(.system(size: 11.5))
                .foregroundStyle(Color.white.opacity(0.45))
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

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(destructive
                                     ? Color(red: 1.0, green: 0.45, blue: 0.45)
                                     : Color.white.opacity(0.85))
                    .frame(width: 22)
                Text(label)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(destructive
                                     ? Color(red: 1.0, green: 0.55, blue: 0.55)
                                     : Color.white)
                Spacer(minLength: 8)
                trailingGlyph
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 13)
            .background(hovering ? Color.white.opacity(0.04) : .clear)
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
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(Color.white.opacity(0.45))
        case .arrow:
            Image(systemName: "chevron.right")
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(Color.white.opacity(0.45))
        case .none:
            EmptyView()
        }
    }
}

// MARK: - Window host

@MainActor
enum AboutWindow {
    private static var window: NSWindow?

    static func show(store: AppStore) {
        if let existing = window {
            existing.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
            return
        }

        let root = AboutView().environment(store)
        let hosting = NSHostingController(rootView: root)
        let win = NSWindow(contentViewController: hosting)
        win.setContentSize(NSSize(width: 480, height: 620))
        win.minSize = NSSize(width: 460, height: 580)
        win.title = "About UpworkBuddy"
        win.titlebarAppearsTransparent = true
        win.titleVisibility = .hidden
        win.styleMask.insert(.fullSizeContentView)
        win.isReleasedWhenClosed = false
        win.center()
        win.delegate = AboutWindowDelegate.shared

        window = win
        NSApp.activate(ignoringOtherApps: true)
        win.makeKeyAndOrderFront(nil)
    }

    static func didClose() {
        window = nil
    }
}

@MainActor
private final class AboutWindowDelegate: NSObject, NSWindowDelegate {
    static let shared = AboutWindowDelegate()
    func windowWillClose(_ notification: Notification) {
        AboutWindow.didClose()
    }
}
