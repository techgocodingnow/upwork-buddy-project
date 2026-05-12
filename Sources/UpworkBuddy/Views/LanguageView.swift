import SwiftUI

/// Settings → Language. Lists every supported `AppLanguage` and persists the
/// user's choice on `AppStore.preferredLanguage`. Selection only takes effect
/// after the app restarts (matches the info banner at the bottom).
struct LanguagePage: View {
    @Bindable var store: AppStore

    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            languageList
        }
    }

    private var languageList: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Text(loc: "Select Language")
                    .font(Theme.body(size: 13.5, weight: .semibold))
                    .foregroundStyle(Theme.textSecondary)
                Rectangle().fill(Theme.divider).frame(height: 1)
            }

            ScrollView {
                VStack(spacing: 8) {
                    ForEach(AppLanguage.allCases) { language in
                        LanguageRow(
                            language: language,
                            isSelected: store.preferredLanguage == language
                        ) {
                            store.preferredLanguage = language
                        }
                    }
                }
                .padding(12)
            }
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Theme.surface.opacity(0.55))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .strokeBorder(Theme.divider, lineWidth: 0.5)
            )
        }
    }

    private var restartNotice: some View {
        HStack(alignment: .firstTextBaseline, spacing: 10) {
            Image(systemName: "info.circle.fill")
                .font(Theme.body(size: 14, weight: .semibold))
                .foregroundStyle(Theme.accent)
            Text(loc: "Language changes will take effect after restarting the app")
                .font(Theme.body(size: 12.5))
                .foregroundStyle(Theme.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Theme.accent.opacity(0.08))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .strokeBorder(Theme.accent.opacity(0.25), lineWidth: 0.5)
        )
    }
}

private struct LanguageRow: View {
    let language: AppLanguage
    let isSelected: Bool
    let action: () -> Void

    @State private var hovering = false

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Text(language.flag)
                    .font(Theme.body(size: 26))
                    .frame(width: 36, alignment: .center)
                VStack(alignment: .leading, spacing: 2) {
                    Text(language.nativeName)
                        .font(Theme.body(size: 13.5, weight: .semibold))
                        .foregroundStyle(Theme.textPrimary)
                    Text(language.englishName)
                        .font(.caption)
                        .foregroundStyle(Theme.textTertiary)
                }
                Spacer(minLength: 0)
                if isSelected {
                    ZStack {
                        Circle()
                            .fill(Theme.accent)
                            .frame(width: 22, height: 22)
                        Image(systemName: "checkmark")
                            .font(Theme.body(size: 11, weight: .bold))
                            .foregroundStyle(Theme.onAccent)
                    }
                    .accessibilityHidden(true)
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(rowBackground)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .strokeBorder(rowBorder, lineWidth: isSelected ? 1 : 0.5)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .onHover { hovering = $0 }
        .accessibilityLabel("\(language.nativeName), \(language.englishName)")
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    private var rowBackground: Color {
        if isSelected { return Theme.accent.opacity(0.10) }
        if hovering   { return Theme.surface.opacity(0.85) }
        return Theme.surface.opacity(0.55)
    }

    private var rowBorder: Color {
        if isSelected { return Theme.accent.opacity(0.55) }
        return Theme.divider.opacity(0.6)
    }
}
