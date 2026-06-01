import SwiftUI
import AppKit

private let supportRepoURL     = URL(string: "https://github.com/techgocodingnow/upwork-buddy-project")!
private let supportIssuesURL   = URL(string: "https://github.com/techgocodingnow/upwork-buddy-project/issues")!
private let gitHubSponsorsURL  = URL(string: "https://github.com/sponsors/techgocodingnow")!

/// Scheme-aware tint colors for Support page feature rows. Brighter on dark,
/// deeper on light — keeps WCAG contrast on both themes.
private enum SupportTint {
    static func success(_ scheme: ColorScheme) -> Color {
        scheme == .dark
            ? Color(red: 0.42, green: 0.88, blue: 0.60)
            : Color(red: 0.16, green: 0.62, blue: 0.36)
    }
    static func info(_ scheme: ColorScheme) -> Color {
        scheme == .dark
            ? Color(red: 0.52, green: 0.74, blue: 1.00)
            : Color(red: 0.22, green: 0.48, blue: 0.86)
    }
    static func privacy(_ scheme: ColorScheme) -> Color {
        scheme == .dark
            ? Color(red: 1.00, green: 0.66, blue: 0.32)
            : Color(red: 0.86, green: 0.45, blue: 0.16)
    }
    static func heart(_ scheme: ColorScheme) -> Color {
        scheme == .dark
            ? Color(red: 1.00, green: 0.50, blue: 0.56)
            : Color(red: 0.92, green: 0.20, blue: 0.28)
    }
    /// GitHub Sponsors brand pink, tuned for contrast on each scheme.
    static func sponsor(_ scheme: ColorScheme) -> Color {
        scheme == .dark
            ? Color(red: 0.92, green: 0.40, blue: 0.66)
            : Color(red: 0.79, green: 0.20, blue: 0.55)
    }
}

/// Inline Support page rendered inside `SettingsContent`. Inherits the
/// active theme background from the parent container.
struct SupportPage: View {
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(spacing: 24) {
            heroBlock
            featuresCard
            supportBlock
            vietnameseSupportBlock
            githubBlock
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Hero

    private var heroBlock: some View {
        VStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(SupportTint.heart(colorScheme).opacity(0.18))
                    .frame(width: 88, height: 88)
                    .blur(radius: 18)
                Image(systemName: "heart.fill")
                    .font(Theme.body(size: 44, weight: .bold))
                    .foregroundStyle(SupportTint.heart(colorScheme))
                    .shadow(color: SupportTint.heart(colorScheme).opacity(0.40), radius: 10, y: 2)
            }
            .accessibilityHidden(true)

            Text(loc: "Support the Project")
                .font(Theme.body(size: 26, weight: .bold))
                .foregroundStyle(Theme.textPrimary)
                .accessibilityAddTraits(.isHeader)

            Text(loc: "UpworkBuddy is free and open source")
                .font(Theme.body(size: 13.5))
                .foregroundStyle(Theme.textSecondary)
        }
        .padding(.top, 8)
    }

    // MARK: - Features card

    private var featuresCard: some View {
        VStack(alignment: .leading, spacing: 22) {
            FeatureRow(
                icon: "checkmark.circle.fill",
                tint: SupportTint.success(colorScheme),
                title: L10n.t("All Features Are Free"),
                detail: L10n.t("Every feature in this app is completely free to use. No premium tiers, no paywalls, no subscriptions.")
            )
            FeatureRow(
                icon: "lock.open.fill",
                tint: SupportTint.info(colorScheme),
                title: L10n.t("Open Source"),
                detail: L10n.t("The source code is publicly available on GitHub. You can inspect, modify, and contribute to the project.")
            )
            FeatureRow(
                icon: "hand.raised.fill",
                tint: SupportTint.privacy(colorScheme),
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

    // MARK: - GitHub Sponsors CTA (primary)

    private var supportBlock: some View {
        VStack(spacing: 14) {
            Text(loc: "If you find this app useful, consider supporting its development")
                .font(Theme.body(size: 12.5))
                .foregroundStyle(Theme.textSecondary)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)

            Button {
                NSWorkspace.shared.open(gitHubSponsorsURL)
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: "heart.fill")
                        .font(Theme.body(size: 14, weight: .bold))
                    Text(loc: "Sponsor on GitHub")
                        .font(Theme.body(size: 14, weight: .bold))
                }
                .foregroundStyle(Color.white)
                .padding(.horizontal, 26)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(SupportTint.sponsor(colorScheme))
                )
            }
            .buttonStyle(.plain)
            .accessibilityLabel(L10n.t("Sponsor on GitHub"))
            .accessibilityHint(L10n.t("Opens donation page in browser"))

            Text(loc: "Your support helps keep this project alive and growing")
                .font(Theme.body(size: 11.5))
                .foregroundStyle(Theme.textTertiary)
                .multilineTextAlignment(.center)
        }
    }

    // MARK: - Vietnamese support (MoMo)

    /// Local donation option for Vietnamese users: a MoMo QR code shipped from
    /// `Resources/donation/momo.JPG` (SwiftPM's `.process` flattens it to the
    /// bundle root). Falls back to a labelled placeholder if the image is
    /// missing from the bundle.
    private var vietnameseSupportBlock: some View {
        VStack(spacing: 14) {
            Text(loc: "Support from Vietnam")
                .font(Theme.body(size: 14.5, weight: .semibold))
                .foregroundStyle(Theme.textPrimary)
                .accessibilityAddTraits(.isHeader)

            Text(loc: "Scan this QR code with the MoMo app to send your support")
                .font(Theme.body(size: 12))
                .foregroundStyle(Theme.textSecondary)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)

            momoQR
                .frame(width: 220, height: 220)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .strokeBorder(Theme.divider, lineWidth: 0.6)
                )
                .accessibilityLabel(L10n.t("MoMo QR code"))
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Theme.surface.opacity(0.6))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(Theme.divider, lineWidth: 0.6)
        )
    }

    @ViewBuilder
    private var momoQR: some View {
        if let url = Bundle.module.url(forResource: "momo", withExtension: "JPG"),
           let nsImage = NSImage(contentsOf: url) {
            Image(nsImage: nsImage)
                .resizable()
                .interpolation(.high)
                .scaledToFit()
        } else {
            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Theme.surface)
                VStack(spacing: 8) {
                    Image(systemName: "qrcode")
                        .font(Theme.body(size: 40, weight: .regular))
                        .foregroundStyle(Theme.textTertiary)
                    Text(loc: "QR code unavailable")
                        .font(Theme.body(size: 11))
                        .foregroundStyle(Theme.textTertiary)
                }
            }
            .frame(height: 180)
            .accessibilityHidden(true)
        }
    }

    // MARK: - GitHub CTA

    private var githubBlock: some View {
        VStack(spacing: 12) {
            Text(loc: "You can also support by")
                .font(Theme.body(size: 12.5))
                .foregroundStyle(Theme.textSecondary)

            Button {
                NSWorkspace.shared.open(supportRepoURL)
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "star.fill")
                        .font(Theme.body(size: 13, weight: .bold))
                    Text(loc: "Starring on GitHub")
                        .font(Theme.body(size: 13, weight: .semibold))
                }
                .foregroundStyle(Theme.onAccent)
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
                .font(Theme.body(size: 20, weight: .semibold))
                .foregroundStyle(tint)
                .frame(width: 26, alignment: .center)
                .padding(.top, 2)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(Theme.body(size: 14.5, weight: .semibold))
                    .foregroundStyle(Theme.textPrimary)
                Text(detail)
                    .font(Theme.body(size: 12.5))
                    .foregroundStyle(Theme.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title). \(detail)") // both pre-localized at call site
    }
}
