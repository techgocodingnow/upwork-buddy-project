import SwiftUI
import AppKit

private let supportRepoURL    = URL(string: "https://github.com/anthropics/claude-code")!
private let supportIssuesURL  = URL(string: "https://github.com/anthropics/claude-code/issues")!
private let buyMeACoffeeURL   = URL(string: "https://buymeacoffee.com/")!

struct SupportView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                heroBlock
                featuresCard
                supportBlock
                githubBlock
            }
            .padding(.horizontal, 28)
            .padding(.vertical, 32)
            .frame(maxWidth: .infinity)
        }
        .background(backdrop.ignoresSafeArea())
        .frame(minWidth: 460, minHeight: 620)
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
        VStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(Color.red.opacity(0.18))
                    .frame(width: 88, height: 88)
                    .blur(radius: 18)
                Image(systemName: "heart.fill")
                    .font(.system(size: 44, weight: .bold))
                    .foregroundStyle(Color(red: 1.0, green: 0.30, blue: 0.36))
                    .shadow(color: Color.red.opacity(0.45), radius: 10, y: 2)
            }

            Text("Support the Project")
                .font(.system(size: 26, weight: .bold))
                .foregroundStyle(Color.white)

            Text("UpworkBuddy is free and open source")
                .font(.system(size: 13.5))
                .foregroundStyle(Color.white.opacity(0.65))
        }
        .padding(.top, 8)
    }

    // MARK: - Features card

    private var featuresCard: some View {
        VStack(alignment: .leading, spacing: 22) {
            FeatureRow(
                icon: "checkmark.circle.fill",
                tint: Color(red: 0.20, green: 0.78, blue: 0.46),
                title: "All Features Are Free",
                detail:"Every feature in this app is completely free to use. No premium tiers, no paywalls, no subscriptions."
            )
            FeatureRow(
                icon: "lock.open.fill",
                tint: Color(red: 0.30, green: 0.60, blue: 1.0),
                title: "Open Source",
                detail:"The source code is publicly available on GitHub. You can inspect, modify, and contribute to the project."
            )
            FeatureRow(
                icon: "hand.raised.fill",
                tint: Color(red: 1.0, green: 0.55, blue: 0.20),
                title: "No Tracking",
                detail:"Your privacy matters. No analytics, no telemetry, no data collection. Everything stays on your Mac."
            )
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white.opacity(0.05))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(Color.white.opacity(0.08), lineWidth: 0.6)
        )
    }

    // MARK: - Coffee CTA

    private var supportBlock: some View {
        VStack(spacing: 14) {
            Text("If you find this app useful, consider supporting its development")
                .font(.system(size: 12.5))
                .foregroundStyle(Color.white.opacity(0.65))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)

            Button {
                NSWorkspace.shared.open(buyMeACoffeeURL)
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: "cup.and.saucer.fill")
                        .font(.system(size: 14, weight: .bold))
                    Text("Buy Me a Coffee")
                        .font(.system(size: 14, weight: .bold))
                }
                .foregroundStyle(Color.black)
                .padding(.horizontal, 26)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color(red: 1.0, green: 0.86, blue: 0.20))
                )
            }
            .buttonStyle(.plain)

            Text("Your support helps keep this project alive and growing")
                .font(.system(size: 11.5))
                .foregroundStyle(Color.white.opacity(0.45))
                .multilineTextAlignment(.center)
        }
    }

    // MARK: - GitHub CTA

    private var githubBlock: some View {
        VStack(spacing: 12) {
            Text("You can also support by")
                .font(.system(size: 12.5))
                .foregroundStyle(Color.white.opacity(0.65))

            Button {
                NSWorkspace.shared.open(supportRepoURL)
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 13, weight: .bold))
                    Text("Starring on GitHub")
                        .font(.system(size: 13, weight: .semibold))
                }
                .foregroundStyle(Color.white)
                .padding(.horizontal, 22)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color.black.opacity(0.55))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .strokeBorder(Color.white.opacity(0.12), lineWidth: 0.6)
                )
            }
            .buttonStyle(.plain)
        }
        .padding(.bottom, 8)
    }
}

private struct FeatureRow: View {
    let icon: String
    let tint: Color
    let title: String
    let detail: String

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(tint)
                .frame(width: 26, alignment: .center)
                .padding(.top, 2)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 14.5, weight: .semibold))
                    .foregroundStyle(Color.white)
                Text(detail)
                    .font(.system(size: 12.5))
                    .foregroundStyle(Color.white.opacity(0.62))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

// MARK: - Window host

@MainActor
enum SupportWindow {
    private static var window: NSWindow?

    static func show() {
        if let existing = window {
            existing.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
            return
        }

        let hosting = NSHostingController(rootView: SupportView())
        let win = NSWindow(contentViewController: hosting)
        win.setContentSize(NSSize(width: 480, height: 680))
        win.minSize = NSSize(width: 460, height: 620)
        win.title = "Support UpworkBuddy"
        win.titlebarAppearsTransparent = true
        win.titleVisibility = .hidden
        win.styleMask.insert(.fullSizeContentView)
        win.isReleasedWhenClosed = false
        win.center()
        win.delegate = SupportWindowDelegate.shared

        window = win
        NSApp.activate(ignoringOtherApps: true)
        win.makeKeyAndOrderFront(nil)
    }

    static func didClose() {
        window = nil
    }
}

@MainActor
private final class SupportWindowDelegate: NSObject, NSWindowDelegate {
    static let shared = SupportWindowDelegate()
    func windowWillClose(_ notification: Notification) {
        SupportWindow.didClose()
    }
}
