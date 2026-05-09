import SwiftUI
import AppKit

// MARK: - Categories

enum SettingsCategory: String, CaseIterable, Identifiable, Hashable {
    case general
    case display
    case shortcuts
    case account

    var id: String { rawValue }

    var label: String {
        switch self {
        case .general:   return "General"
        case .display:   return "Display"
        case .shortcuts: return "Shortcuts"
        case .account:   return "Account"
        }
    }

    var subtitle: String {
        switch self {
        case .general:   return "Refresh, login behavior, and goals"
        case .display:   return "Menu bar appearance and dashboard"
        case .shortcuts: return "Global keyboard shortcuts"
        case .account:   return "Connected Upwork session"
        }
    }

    var systemImage: String {
        switch self {
        case .general:   return "gearshape"
        case .display:   return "rectangle.on.rectangle"
        case .shortcuts: return "command"
        case .account:   return "person.crop.circle"
        }
    }
}

// MARK: - Root

struct SettingsRootView: View {
    @State private var selection: SettingsCategory = .general
    @Environment(AppStore.self) private var store

    var body: some View {
        HStack(spacing: 0) {
            SettingsSidebar(selection: $selection)
                .frame(width: 200)
            Divider().background(Theme.divider)
            SettingsContent(category: selection)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(Theme.bgGradient.ignoresSafeArea())
        .frame(minWidth: 640, minHeight: 480)
        .id(store.appTheme)
    }
}

// Compatibility shim — old call sites still pass `SettingsView()`.
struct SettingsView: View {
    var body: some View { SettingsRootView() }
}

// MARK: - Sidebar

private struct SettingsSidebar: View {
    @Binding var selection: SettingsCategory

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 8) {
                Image(systemName: "briefcase.fill")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(Theme.accent)
                Text("UpworkBuddy")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Theme.textPrimary)
            }
            .padding(.horizontal, 16)
            .padding(.top, 18)
            .padding(.bottom, 18)

            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    sidebarGroup(title: "Settings", items: SettingsCategory.allCases)
                }
                .padding(.horizontal, 8)
                .padding(.bottom, 16)
            }

            Spacer(minLength: 0)
            Divider().background(Theme.divider)
            footer
        }
        .background(Theme.chipBg.opacity(0.35))
    }

    private func sidebarGroup(title: String, items: [SettingsCategory]) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title.uppercased())
                .font(.caption2.weight(.semibold))
                .tracking(0.6)
                .foregroundStyle(Theme.textTertiary)
                .padding(.horizontal, 10)
                .padding(.bottom, 4)

            ForEach(items) { item in
                SidebarRow(
                    label: item.label,
                    systemImage: item.systemImage,
                    isSelected: selection == item
                ) {
                    selection = item
                }
            }
        }
    }

    private var footer: some View {
        HStack(spacing: 0) {
            FooterIcon(systemImage: "info.circle", help: "About") {
                NSApp.orderFrontStandardAboutPanel(nil)
            }
            FooterIcon(systemImage: "questionmark.circle", help: "Support") {
                if let url = URL(string: "https://github.com/anthropics/claude-code/issues") {
                    NSWorkspace.shared.open(url)
                }
            }
            Spacer()
            FooterIcon(systemImage: "power", help: "Quit UpworkBuddy") {
                NSApp.terminate(nil)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 8)
    }
}

private struct SidebarRow: View {
    let label: String
    let systemImage: String
    let isSelected: Bool
    let action: () -> Void

    @State private var hovering = false

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Image(systemName: systemImage)
                    .font(.system(size: 12, weight: .medium))
                    .frame(width: 18)
                Text(label)
                    .font(.system(size: 13, weight: isSelected ? .semibold : .regular))
                Spacer()
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 7)
            .foregroundStyle(isSelected ? Color.white : Theme.textPrimary)
            .background(
                RoundedRectangle(cornerRadius: 7, style: .continuous)
                    .fill(rowFill)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .onHover { hovering = $0 }
    }

    private var rowFill: Color {
        if isSelected { return Theme.accent }
        if hovering   { return Theme.accent.opacity(0.12) }
        return .clear
    }
}

private struct FooterIcon: View {
    let systemImage: String
    let help: String
    let action: () -> Void
    @State private var hovering = false

    var body: some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(hovering ? Theme.accent : Theme.textSecondary)
                .frame(width: 28, height: 28)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(hovering ? Theme.accent.opacity(0.12) : .clear)
                )
        }
        .buttonStyle(.plain)
        .onHover { hovering = $0 }
        .help(help)
    }
}

// MARK: - Content

private struct SettingsContent: View {
    let category: SettingsCategory
    @Environment(AppStore.self) private var store

    var body: some View {
        @Bindable var store = store
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                pageHeader

                switch category {
                case .general:   GeneralPage(store: store)
                case .display:   DisplayPage(store: store)
                case .shortcuts: ShortcutsPage()
                case .account:   AccountPage(store: store)
                }
            }
            .padding(28)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var pageHeader: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(category.label)
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(Theme.textPrimary)
            Text(category.subtitle)
                .font(.system(size: 13))
                .foregroundStyle(Theme.textSecondary)
        }
        .padding(.bottom, 8)
    }
}

// MARK: - Card

private struct SettingsCard<Content: View>: View {
    let title: String
    var subtitle: String? = nil
    var systemImage: String? = nil
    @ViewBuilder let content: () -> Content

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            if let systemImage {
                Image(systemName: systemImage)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Theme.accent)
                    .frame(width: 26, height: 26)
                    .background(
                        RoundedRectangle(cornerRadius: 7)
                            .fill(Theme.accent.opacity(0.12))
                    )
            }
            VStack(alignment: .leading, spacing: 8) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Theme.textPrimary)
                    if let subtitle {
                        Text(subtitle)
                            .font(.caption)
                            .foregroundStyle(Theme.textTertiary)
                    }
                }
                content()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Theme.surface.opacity(0.85))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .strokeBorder(Theme.divider, lineWidth: 0.5)
        )
    }
}

// MARK: - Pages

private struct GeneralPage: View {
    @Bindable var store: AppStore

    var body: some View {
        VStack(spacing: 12) {
            SettingsCard(
                title: "Refresh interval",
                subtitle: "How often UpworkBuddy polls for new earnings.",
                systemImage: "arrow.clockwise"
            ) {
                Picker("", selection: refreshMinutesBinding) {
                    Text("1 min").tag(1)
                    Text("5 min").tag(5)
                    Text("15 min").tag(15)
                    Text("30 min").tag(30)
                }
                .pickerStyle(.segmented)
                .labelsHidden()
            }

            SettingsCard(
                title: "Launch at login",
                subtitle: "Open UpworkBuddy automatically when you sign in to your Mac.",
                systemImage: "power"
            ) {
                Toggle("", isOn: $store.launchAtLogin)
                    .labelsHidden()
                    .toggleStyle(.switch)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            SettingsCard(
                title: "Daily goal",
                subtitle: "Hours target shown as a ring on the dashboard. 0 hides the ring.",
                systemImage: "target"
            ) {
                HStack {
                    Stepper(value: $store.goalHoursDaily, in: 0...24, step: 0.5) {
                        EmptyView()
                    }
                    .labelsHidden()
                    Text(goalLabel(store.goalHoursDaily))
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(Theme.textPrimary)
                    Spacer()
                }
            }

            SettingsCard(
                title: "Weekly goal",
                subtitle: "Total hours target across the work week.",
                systemImage: "calendar"
            ) {
                HStack {
                    Stepper(value: $store.goalHoursWeekly, in: 0...80, step: 1) {
                        EmptyView()
                    }
                    .labelsHidden()
                    Text(goalLabel(store.goalHoursWeekly))
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(Theme.textPrimary)
                    Spacer()
                }
            }
        }
    }

    private var refreshMinutesBinding: Binding<Int> {
        Binding(
            get: { max(1, store.refreshIntervalSeconds / 60) },
            set: { store.refreshIntervalSeconds = $0 * 60 }
        )
    }

    private func goalLabel(_ hours: Double) -> String {
        if hours <= 0 { return "Off" }
        let whole = Int(hours)
        let frac = hours - Double(whole)
        if frac < 0.05 { return "\(whole) h" }
        return String(format: "%.1f h", hours)
    }
}

private struct DisplayPage: View {
    @Bindable var store: AppStore

    var body: some View {
        VStack(spacing: 12) {
            SettingsCard(
                title: "Theme",
                subtitle: "Color palette used across the dashboard, menu bar, and settings.",
                systemImage: "paintpalette"
            ) {
                VStack(alignment: .leading, spacing: 10) {
                    Picker("", selection: $store.appTheme) {
                        ForEach(AppTheme.allCases) { theme in
                            Text(theme.label).tag(theme)
                        }
                    }
                    .pickerStyle(.segmented)
                    .labelsHidden()
                    HStack(spacing: 12) {
                        ForEach(AppTheme.allCases) { theme in
                            ThemeSwatch(theme: theme, isSelected: store.appTheme == theme)
                                .onTapGesture { store.appTheme = theme }
                        }
                        Spacer()
                    }
                }
            }

            SettingsCard(
                title: "Menu bar shows",
                subtitle: "Which value appears next to the icon.",
                systemImage: "menubar.rectangle"
            ) {
                Picker("", selection: $store.menuBarMetric) {
                    Text("Hours today").tag(MenuBarMetric.hours)
                    Text("Earnings today").tag(MenuBarMetric.earnings)
                }
                .pickerStyle(.segmented)
                .labelsHidden()
            }

            SettingsCard(
                title: "Menu bar style",
                subtitle: "Compact display variants.",
                systemImage: "rectangle.compress.vertical"
            ) {
                Picker("", selection: $store.menuBarIconStyle) {
                    ForEach(MenuBarIconStyle.allCases, id: \.self) { style in
                        Text(style.label).tag(style)
                    }
                }
                .pickerStyle(.segmented)
                .labelsHidden()
            }

            SettingsCard(
                title: "Dashboard primary",
                subtitle: "Controls which value renders large in the popover header.",
                systemImage: "textformat.size.larger"
            ) {
                Picker("", selection: $store.dashboardMetric) {
                    Text("Earnings").tag(MenuBarMetric.earnings)
                    Text("Hours").tag(MenuBarMetric.hours)
                }
                .pickerStyle(.segmented)
                .labelsHidden()
            }

            SettingsCard(
                title: "Hide sensitive amounts",
                subtitle: "Masks earnings, rates, and totals across the app and menu bar.",
                systemImage: "eye.slash"
            ) {
                Toggle("", isOn: $store.hideSensitive)
                    .labelsHidden()
                    .toggleStyle(.switch)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

private struct ShortcutsPage: View {
    @Environment(AppStore.self) private var store

    var body: some View {
        VStack(spacing: 12) {
            ForEach(ShortcutAction.allCases) { action in
                ShortcutRow(action: action, store: store)
            }

            // Info banner
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: "info.circle.fill")
                    .font(.system(size: 14))
                    .foregroundStyle(Theme.accent)
                VStack(alignment: .leading, spacing: 4) {
                    Text("Global shortcuts")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Theme.textPrimary)
                    Text("Shortcuts work from any application. Each shortcut must include at least one modifier key (⌘, ⌥, ⌃, or ⇧). Press Esc while recording to cancel.")
                        .font(.caption)
                        .foregroundStyle(Theme.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer()
            }
            .padding(14)
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
}

private struct ShortcutRow: View {
    let action: ShortcutAction
    let store: AppStore

    var body: some View {
        SettingsCard(
            title: action.label,
            subtitle: action.subtitle,
            systemImage: action.systemImage
        ) {
            HStack {
                ShortcutRecorder(
                    shortcut: store.shortcuts[action] ?? nil,
                    onCapture: { shortcut in
                        store.setShortcut(shortcut, for: action)
                    },
                    onClear: {
                        store.setShortcut(nil, for: action)
                    }
                )
                Spacer()
                Button("Reset") {
                    store.resetShortcut(for: action)
                }
                .buttonStyle(.borderless)
                .font(.caption)
                .foregroundStyle(Theme.textTertiary)
            }
        }
    }
}

private struct AccountPage: View {
    @Bindable var store: AppStore
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 12) {
            SettingsCard(
                title: "Upwork connection",
                subtitle: store.isAuthenticated ? "You're signed in via Upwork OAuth." : "Not connected.",
                systemImage: "link.circle.fill"
            ) {
                HStack(spacing: 8) {
                    Circle()
                        .fill(store.isAuthenticated ? Color.green : Color.gray)
                        .frame(width: 8, height: 8)
                    Text(store.isAuthenticated ? "Connected" : "Disconnected")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(Theme.textPrimary)
                    Spacer()
                }
            }

            SettingsCard(
                title: "Currency",
                subtitle: "FX support coming in v2.",
                systemImage: "dollarsign.circle"
            ) {
                Picker("", selection: $store.currency) {
                    Text("USD").tag("USD")
                }
                .pickerStyle(.menu)
                .labelsHidden()
                .disabled(true)
            }

            SettingsCard(
                title: "Disconnect",
                subtitle: "Sign out and clear cached earnings on this Mac.",
                systemImage: "rectangle.portrait.and.arrow.right"
            ) {
                Button(role: .destructive) {
                    Task {
                        await store.logout()
                    }
                } label: {
                    Label("Disconnect Upwork", systemImage: "rectangle.portrait.and.arrow.right")
                }
                .controlSize(.regular)
            }
        }
    }
}

// MARK: - ThemeSwatch

private struct ThemeSwatch: View {
    let theme: AppTheme
    let isSelected: Bool

    var body: some View {
        let palette = theme.palette
        VStack(spacing: 6) {
            ZStack {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(LinearGradient(colors: [palette.bgTop, palette.bgBottom],
                                         startPoint: .top, endPoint: .bottom))
                HStack(spacing: 4) {
                    Circle().fill(palette.accent).frame(width: 10, height: 10)
                    Circle().fill(palette.accentDeep).frame(width: 10, height: 10)
                    Circle().fill(palette.accentSoft).frame(width: 10, height: 10)
                }
            }
            .frame(width: 64, height: 36)
            .overlay(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .strokeBorder(isSelected ? palette.accent : palette.divider,
                                  lineWidth: isSelected ? 1.5 : 0.5)
            )

            Text(theme.label)
                .font(.system(size: 11, weight: isSelected ? .semibold : .regular))
                .foregroundStyle(Theme.textSecondary)
        }
        .contentShape(Rectangle())
    }
}

// MARK: - KeyCap

private struct KeyCap: View {
    let label: String
    init(_ label: String) { self.label = label }

    var body: some View {
        Text(label)
            .font(.system(size: 12, weight: .semibold, design: .monospaced))
            .foregroundStyle(Theme.textPrimary)
            .frame(minWidth: 22, minHeight: 22)
            .padding(.horizontal, 4)
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .fill(Theme.chipBg)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .strokeBorder(Theme.divider, lineWidth: 0.5)
            )
    }
}
