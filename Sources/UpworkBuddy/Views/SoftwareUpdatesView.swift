import SwiftUI
import AppKit

/// "Software Updates" settings page. Matches the design mock: hero header,
/// version-info card stack, automatic-updates toggle, prominent "Check for
/// Updates" CTA, "Secure Updates" notice.
struct SoftwareUpdatesPage: View {
    @State private var service = UpdateService.shared
    @State private var hoveringCheck = false
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            sectionLabel("Version Information")
            VStack(spacing: 8) {
                infoRow(
                    icon: "app.badge",
                    label: L10n.t("Current Version"),
                    value: appVersion
                )
                infoRow(
                    icon: "clock",
                    label: L10n.t("Last Checked"),
                    value: lastCheckedDescription
                )
            }

            Divider().background(Theme.divider).padding(.vertical, 4)

            sectionLabel("Update Preferences")
            autoUpdateToggleCard

            checkButton

            secureUpdatesNotice
        }
    }

    // MARK: - Info card

    private func infoRow(icon: String, label: String, value: String) -> some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(Theme.accent.opacity(0.14))
                    .frame(width: 32, height: 32)
                Image(systemName: icon)
                    .font(Theme.body(size: 14, weight: .semibold))
                    .foregroundStyle(Theme.accentDeep)
            }
            Text(label)
                .font(Theme.body(size: 13.5, weight: .semibold))
                .foregroundStyle(Theme.textPrimary)
            Spacer(minLength: 8)
            Text(value)
                .font(.system(size: 12.5, weight: .medium, design: .monospaced))
                .foregroundStyle(Theme.textSecondary)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Theme.surface.opacity(0.85))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .strokeBorder(Theme.divider, lineWidth: 0.5)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel(L10n.t("%@: %@", label, value))
    }

    // MARK: - Auto update toggle

    private var autoUpdateToggleCard: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(Theme.accent.opacity(0.14))
                    .frame(width: 32, height: 32)
                Image(systemName: "arrow.triangle.2.circlepath")
                    .font(Theme.body(size: 14, weight: .semibold))
                    .foregroundStyle(Theme.accentDeep)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(loc: "Automatic Updates")
                    .font(Theme.body(size: 13.5, weight: .semibold))
                    .foregroundStyle(Theme.textPrimary)
                Text(loc: "Automatically check for and download updates daily")
                    .font(Theme.body(size: 11.5))
                    .foregroundStyle(Theme.textSecondary)
            }
            Spacer(minLength: 8)
            Toggle("", isOn: Binding(
                get: { service.automaticChecksEnabled },
                set: { service.automaticChecksEnabled = $0 }
            ))
            .labelsHidden()
            .toggleStyle(.switch)
            .tint(Theme.accent)
            .accessibilityLabel(L10n.t("Automatic Updates"))
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Theme.surface.opacity(0.85))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .strokeBorder(Theme.divider, lineWidth: 0.5)
        )
    }

    // MARK: - CTA

    private var checkButton: some View {
        Button {
            service.checkForUpdates()
        } label: {
            HStack(spacing: 8) {
                if service.isCheckingForUpdates {
                    ProgressView()
                        .controlSize(.small)
                        .tint(.white)
                } else {
                    Image(systemName: "arrow.down.circle.fill")
                        .font(Theme.body(size: 15, weight: .semibold))
                }
                Text(loc: service.isCheckingForUpdates ? "Checking…" : "Check for Updates")
                    .font(Theme.body(size: 14, weight: .semibold))
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Theme.accentDeep.opacity(hoveringCheck ? 0.92 : 1.0))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .strokeBorder(Color.white.opacity(0.18), lineWidth: 0.6)
            )
            .shadow(color: Theme.accent.opacity(0.30), radius: 10, y: 4)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(!service.canCheckForUpdates || service.isCheckingForUpdates)
        .opacity(service.canCheckForUpdates ? 1 : 0.6)
        .onHover { hoveringCheck = $0 }
        .accessibilityLabel(L10n.t("Check for Updates"))
    }

    // MARK: - Secure notice

    private var secureUpdatesNotice: some View {
        let info = SeverityColor.info(colorScheme)
        return HStack(alignment: .top, spacing: 12) {
            Image(systemName: "info.circle.fill")
                .font(Theme.body(size: 14))
                .foregroundStyle(info)
            VStack(alignment: .leading, spacing: 4) {
                Text(loc: "Secure Updates")
                    .font(Theme.body(size: 13, weight: .semibold))
                    .foregroundStyle(Theme.textPrimary)
                Text(loc: "All updates are cryptographically signed and verified before installation")
                    .font(Theme.body(size: 11.5))
                    .foregroundStyle(Theme.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer(minLength: 0)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: Theme.radius(10), style: .continuous)
                .fill(info.opacity(colorScheme == .dark ? 0.12 : 0.08))
        )
        .overlay(
            RoundedRectangle(cornerRadius: Theme.radius(10), style: .continuous)
                .strokeBorder(info.opacity(0.30), lineWidth: 0.5)
        )
    }

    // MARK: - Helpers

    private func sectionLabel(_ text: String) -> some View {
        Text(L10n.t(text))
            .font(Theme.body(size: 13.5, weight: .semibold))
            .foregroundStyle(Theme.textPrimary)
            .padding(.top, 4)
    }

    private var appVersion: String {
        let short = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "0.0.0"
        let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "0"
        return "v\(short) (\(build))"
    }

    private var lastCheckedDescription: String {
        guard let date = service.lastCheckedDate else { return L10n.t("Never") }
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}
