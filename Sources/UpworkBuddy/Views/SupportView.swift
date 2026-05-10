import SwiftUI
import AppKit

private let supportRepoURL    = URL(string: "https://github.com/anthropics/claude-code")!
private let supportIssuesURL  = URL(string: "https://github.com/anthropics/claude-code/issues")!
private let buyMeACoffeeURL   = URL(string: "https://buymeacoffee.com/")!

/// Inline Support page rendered inside `SettingsContent`. Inherits the
/// active theme background from the parent container.
struct SupportPage: View {
    var body: some View {
        VStack(spacing: 24) {
            heroBlock
            featuresCard
            supportBlock
            githubBlock
        }
        .frame(maxWidth: .infinity)
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
            .accessibilityHidden(true)

            Text(loc: "Support the Project")
                .font(.system(size: 26, weight: .bold))
                .foregroundStyle(Theme.textPrimary)
                .accessibilityAddTraits(.isHeader)

            Text(loc: "UpworkBuddy is free and open source")
                .font(.system(size: 13.5))
                .foregroundStyle(Theme.textSecondary)
        }
        .padding(.top, 8)
    }

    // MARK: - Features card

    private var featuresCard: some View {
        VStack(alignment: .leading, spacing: 22) {
            FeatureRow(
                icon: "checkmark.circle.fill",
                tint: Color(red: 0.20, green: 0.78, blue: 0.46),
                title: L10n.t("All Features Are Free"),
                detail: L10n.t("Every feature in this app is completely free to use. No premium tiers, no paywalls, no subscriptions.")
            )
            FeatureRow(
                icon: "lock.open.fill",
                tint: Color(red: 0.30, green: 0.60, blue: 1.0),
                title: L10n.t("Open Source"),
                detail: L10n.t("The source code is publicly available on GitHub. You can inspect, modify, and contribute to the project.")
            )
            FeatureRow(
                icon: "hand.raised.fill",
                tint: Color(red: 1.0, green: 0.55, blue: 0.20),
                title: L10n.t("No Tracking"),
                detail: L10n.t("Your privacy matters. No analytics, no telemetry, no data collection. Everything stays on your Mac.")
            )
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Theme.surface.opacity(0.6))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(Theme.divider, lineWidth: 0.6)
        )
    }

    // MARK: - Coffee CTA

    private var supportBlock: some View {
        VStack(spacing: 14) {
            Text(loc: "If you find this app useful, consider supporting its development")
                .font(.system(size: 12.5))
                .foregroundStyle(Theme.textSecondary)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)

            Button {
                NSWorkspace.shared.open(buyMeACoffeeURL)
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: "cup.and.saucer.fill")
                        .font(.system(size: 14, weight: .bold))
                    Text(loc: "Buy Me a Coffee")
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
            .accessibilityLabel(L10n.t("Buy Me a Coffee"))
            .accessibilityHint(L10n.t("Opens donation page in browser"))

            Text(loc: "Your support helps keep this project alive and growing")
                .font(.system(size: 11.5))
                .foregroundStyle(Theme.textTertiary)
                .multilineTextAlignment(.center)
        }
    }

    // MARK: - GitHub CTA

    private var githubBlock: some View {
        VStack(spacing: 12) {
            Text(loc: "You can also support by")
                .font(.system(size: 12.5))
                .foregroundStyle(Theme.textSecondary)

            Button {
                NSWorkspace.shared.open(supportRepoURL)
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 13, weight: .bold))
                    Text(loc: "Starring on GitHub")
                        .font(.system(size: 13, weight: .semibold))
                }
                .foregroundStyle(Color.white)
                .padding(.horizontal, 22)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Theme.accentDeep)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .strokeBorder(Theme.accentDeep.opacity(0.4), lineWidth: 0.6)
                )
            }
            .buttonStyle(.plain)
            .accessibilityLabel(L10n.t("Star on GitHub"))
            .accessibilityHint(L10n.t("Opens GitHub repo"))
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
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 14.5, weight: .semibold))
                    .foregroundStyle(Theme.textPrimary)
                Text(detail)
                    .font(.system(size: 12.5))
                    .foregroundStyle(Theme.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title). \(detail)") // both pre-localized at call site
    }
}
