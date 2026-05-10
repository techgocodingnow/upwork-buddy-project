import SwiftUI
import AppKit
import UserNotifications

// MARK: - Categories

enum SettingsCategory: String, CaseIterable, Identifiable, Hashable {
    case general
    case goals
    case display
    case language
    case shortcuts
    case account
    case softwareUpdates
    case support
    case about

    var id: String { rawValue }

    /// Categories that appear in the main sidebar list with ⌘1…⌘N shortcuts.
    static let primaryCases: [SettingsCategory] = [.general, .goals, .display, .language, .shortcuts, .account, .softwareUpdates]

    /// English source string used as the localization key for the sidebar /
    /// page header label.
    var label: String {
        switch self {
        case .general:         return L10n.t("General")
        case .goals:           return L10n.t("Goals")
        case .display:         return L10n.t("Display")
        case .language:        return L10n.t("Language")
        case .shortcuts:       return L10n.t("Shortcuts")
        case .account:         return L10n.t("Account")
        case .softwareUpdates: return L10n.t("Software Updates")
        case .support:         return L10n.t("Support")
        case .about:           return L10n.t("About")
        }
    }

    /// Localized subtitle for the page header.
    var subtitle: String {
        switch self {
        case .general:         return L10n.t("Refresh cadence and login behavior")
        case .goals:           return L10n.t("Hours and earnings targets, with notifications")
        case .display:         return L10n.t("Theme, menu bar, and dashboard")
        case .language:        return L10n.t("Choose your preferred language")
        case .shortcuts:       return L10n.t("Global keyboard shortcuts")
        case .account:         return L10n.t("Connected Upwork session")
        case .softwareUpdates: return L10n.t("Keep your app up to date")
        case .support:         return L10n.t("Support the project")
        case .about:           return L10n.t("About UpworkBuddy")
        }
    }

    var systemImage: String {
        switch self {
        case .general:         return "gearshape"
        case .goals:           return "target"
        case .display:         return "rectangle.on.rectangle"
        case .language:        return "globe"
        case .shortcuts:       return "command"
        case .account:         return "person.crop.circle"
        case .softwareUpdates: return "arrow.down.circle"
        case .support:         return "heart"
        case .about:           return "info.circle"
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
                .frame(width: 212)
            Divider().background(Theme.divider)
            SettingsContent(category: selection)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(Theme.bgGradient.ignoresSafeArea())
        .frame(minWidth: 760, minHeight: 520)
        .id(store.appTheme)
        .focusEffectDisabled()
        .background {
            // Hidden command pads register ⌘1…⌘5 for sidebar jumps.
            ForEach(Array(SettingsCategory.primaryCases.enumerated()), id: \.element.id) { idx, cat in
                Button("") { selection = cat }
                    .keyboardShortcut(KeyEquivalent(Character("\(idx + 1)")), modifiers: .command)
                    .opacity(0)
                    .frame(width: 0, height: 0)
            }
        }
    }
}

// Compatibility shim for older call sites.
struct SettingsView: View {
    var body: some View { SettingsRootView() }
}

// MARK: - Sidebar

private struct SettingsSidebar: View {
    @Binding var selection: SettingsCategory
    @Environment(AppStore.self) private var store

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            brandHeader
            Divider().background(Theme.divider.opacity(0.5))

            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    sidebarGroup(title: "Settings", items: SettingsCategory.primaryCases)
                }
                .padding(.horizontal, 10)
                .padding(.top, 14)
                .padding(.bottom, 16)
            }

            Spacer(minLength: 0)
            Divider().background(Theme.divider.opacity(0.5))
            footer
        }
        .background(
            ZStack(alignment: .topTrailing) {
                Theme.chipBg.opacity(0.32)
                DotPattern()
                    .foregroundStyle(Theme.textTertiary.opacity(0.10))
                    .allowsHitTesting(false)
                Rectangle()
                    .fill(Theme.divider.opacity(0.4))
                    .frame(width: 1)
                    .frame(maxHeight: .infinity)
            }
        )
    }

    private var brandHeader: some View {
        HStack(spacing: 9) {
            ZStack {
                RoundedRectangle(cornerRadius: 7, style: .continuous)
                    .fill(Theme.accent.opacity(0.16))
                    .frame(width: 26, height: 26)
                Image(systemName: "briefcase.fill")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(Theme.accentDeep)
            }
            .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 0) {
                (
                    Text(loc: "Upwork")
                        .foregroundStyle(Theme.textPrimary)
                    + Text(loc: "Buddy")
                        .foregroundStyle(Theme.accentDeep)
                )
                .font(.system(size: 13.5, weight: .semibold))
                .accessibilityLabel(L10n.t("Upwork Buddy"))
                .accessibilityAddTraits(.isHeader)
                Text(loc: "Settings")
                    .font(.system(size: 10, weight: .medium))
                    .tracking(0.7)
                    .foregroundStyle(Theme.textTertiary)
            }
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 16)
    }

    private func sidebarGroup(title: String, items: [SettingsCategory]) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 6) {
                Rectangle().fill(Theme.accent).frame(width: 10, height: 1)
                Text(L10n.t(title).uppercased(with: .current))
                    .font(.system(size: 9.5, weight: .semibold))
                    .tracking(1.1)
                    .foregroundStyle(Theme.textTertiary)
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 6)

            ForEach(Array(items.enumerated()), id: \.element.id) { idx, item in
                SidebarRow(
                    label: item.label,
                    systemImage: item.systemImage,
                    keyHint: "⌘\(idx + 1)",
                    isSelected: selection == item
                ) {
                    selection = item
                }
            }
        }
    }

    private var footer: some View {
        HStack(spacing: 0) {
            FooterIcon(
                systemImage: "heart",
                label: "Support",
                help: "Support the project",
                isActive: selection == .support
            ) {
                selection = .support
            }
            FooterIcon(
                systemImage: "info.circle",
                label: "About",
                help: "About UpworkBuddy",
                isActive: selection == .about
            ) {
                selection = .about
            }
            FooterIcon(
                systemImage: "power",
                label: "Quit",
                help: "Quit UpworkBuddy",
                isActive: false
            ) {
                NSApp.terminate(nil)
            }
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 10)
    }
}

private struct SidebarRow: View {
    let label: String
    let systemImage: String
    let keyHint: String
    let isSelected: Bool
    let action: () -> Void

    @State private var hovering = false
    @FocusState private var focused: Bool

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Image(systemName: systemImage)
                    .font(.system(size: 12, weight: .medium))
                    .frame(width: 18)
                Text(L10n.t(label))
                    .font(.system(size: 13, weight: isSelected ? .semibold : .regular))
                Spacer()
                Text(keyHint)
                    .font(.system(size: 10, weight: .medium, design: .monospaced))
                    .foregroundStyle(isSelected
                                     ? Color.white.opacity(0.9)
                                     : Theme.textTertiary.opacity(hovering ? 0.95 : 0.55))
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 7)
            .foregroundStyle(isSelected ? Color.white : Theme.textPrimary)
            .background(
                RoundedRectangle(cornerRadius: 7, style: .continuous)
                    .fill(rowFill)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 7, style: .continuous)
                    .strokeBorder(focused ? Theme.accent : .clear,
                                  lineWidth: focused ? 1.5 : 0)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .focusable()
        .focused($focused)
        .onHover { hovering = $0 }
        .accessibilityLabel("\(L10n.t(label)), \(keyHint)")
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    private var rowFill: Color {
        if isSelected { return Theme.accentDeep }
        if hovering   { return Theme.accent.opacity(0.12) }
        return .clear
    }
}

private struct FooterIcon: View {
    let systemImage: String
    let label: String
    let help: String
    var isActive: Bool = false
    let action: () -> Void
    @State private var hovering = false

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: systemImage)
                    .font(.system(size: 14, weight: .medium))
                    .frame(height: 18)
                Text(L10n.t(label))
                    .font(.system(size: 10.5, weight: .medium))
                    .lineLimit(1)
            }
            .foregroundStyle(foreground)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(background)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .onHover { hovering = $0 }
        .help(L10n.t(help))
        .accessibilityLabel(L10n.t(label))
        .accessibilityHint(L10n.t(help))
        .accessibilityAddTraits(isActive ? .isSelected : [])
    }

    private var foreground: Color {
        if isActive { return Theme.accentDeep }
        if hovering { return Theme.accentDeep }
        return Theme.textSecondary
    }

    private var background: Color {
        if isActive { return Theme.accent.opacity(0.16) }
        if hovering { return Theme.accent.opacity(0.10) }
        return .clear
    }
}

// MARK: - Atmosphere

private struct DotPattern: View {
    var spacing: CGFloat = 14
    var radius: CGFloat = 0.9

    var body: some View {
        Canvas { ctx, size in
            let cols = Int(size.width / spacing) + 1
            let rows = Int(size.height / spacing) + 1
            for r in 0..<rows {
                for c in 0..<cols {
                    let x = CGFloat(c) * spacing + spacing / 2
                    let y = CGFloat(r) * spacing + spacing / 2
                    let rect = CGRect(x: x - radius, y: y - radius,
                                      width: radius * 2, height: radius * 2)
                    ctx.fill(Path(ellipseIn: rect), with: .style(.foreground))
                }
            }
        }
    }
}

// MARK: - Content

private struct SettingsContent: View {
    let category: SettingsCategory
    @Environment(AppStore.self) private var store

    var body: some View {
        @Bindable var store = store
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                SettingsPageHeader(category: category)
                Group {
                    switch category {
                    case .general:         GeneralPage(store: store)
                    case .goals:           GoalsPage(store: store)
                    case .display:         DisplayPage(store: store)
                    case .language:        LanguagePage(store: store)
                    case .shortcuts:       ShortcutsPage()
                    case .account:         AccountPage(store: store)
                    case .softwareUpdates: SoftwareUpdatesPage()
                    case .support:         SupportPage()
                    case .about:           AboutPage()
                    }
                }
                .id(category)
                .transition(.asymmetric(
                    insertion: .opacity.combined(with: .offset(y: 6)),
                    removal: .opacity
                ))
            }
            .padding(.horizontal, 32)
            .padding(.vertical, 28)
            .frame(maxWidth: .infinity, alignment: .leading)
            .animation(.smooth(duration: 0.25), value: category)
        }
    }
}

private struct SettingsPageHeader: View {
    let category: SettingsCategory

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(category.label)
                .font(.system(size: 26, weight: .bold))
                .tracking(-0.5)
                .foregroundStyle(Theme.textPrimary)
            HStack(spacing: 8) {
                Rectangle().fill(Theme.accent).frame(width: 18, height: 1.5)
                Text(category.subtitle)
                    .font(.system(size: 13))
                    .foregroundStyle(Theme.textSecondary)
            }
        }
    }
}

// MARK: - Section primitive

private struct SettingsSection<Content: View>: View {
    let title: String
    var caption: String? = nil
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Text(L10n.t(title).uppercased(with: .current))
                    .font(.system(size: 10, weight: .semibold))
                    .tracking(1.2)
                    .foregroundStyle(Theme.textTertiary)
                Rectangle().fill(Theme.divider).frame(height: 1)
                if let caption {
                    Text(L10n.t(caption))
                        .font(.caption)
                        .foregroundStyle(Theme.textTertiary)
                        .layoutPriority(1)
                }
            }
            content()
        }
    }
}

// MARK: - Card

private struct SettingsCard<Content: View>: View {
    let title: String
    var subtitle: String? = nil
    var systemImage: String? = nil
    var trailingMinWidth: CGFloat = 0
    var layout: Layout = .horizontal
    @ViewBuilder let content: () -> Content

    enum Layout {
        case horizontal
        case stacked
    }

    var body: some View {
        Group {
            switch layout {
            case .horizontal: horizontalBody
            case .stacked:    stackedBody
            }
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

    private var iconBadge: some View {
        Group {
            if let systemImage {
                Image(systemName: systemImage)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Theme.accentDeep)
                    .frame(width: 28, height: 28)
                    .background(
                        RoundedRectangle(cornerRadius: 7)
                            .fill(Theme.accent.opacity(0.12))
                    )
            }
        }
    }

    private var titleBlock: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(L10n.t(title))
                .font(.system(size: 13.5, weight: .semibold))
                .foregroundStyle(Theme.textPrimary)
                .lineLimit(1)
            if let subtitle {
                Text(L10n.t(subtitle))
                    .font(.caption)
                    .foregroundStyle(Theme.textTertiary)
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private var horizontalBody: some View {
        HStack(alignment: .center, spacing: 12) {
            iconBadge
            titleBlock
                .frame(maxWidth: .infinity, alignment: .leading)
            Spacer(minLength: 12)
            content()
                .frame(minWidth: trailingMinWidth, alignment: .trailing)
                .layoutPriority(1)
        }
    }

    private var stackedBody: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .center, spacing: 12) {
                iconBadge
                titleBlock
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            content()
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

// MARK: - General

private struct GeneralPage: View {
    @Bindable var store: AppStore

    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            SettingsSection(title: "Sync") {
                RefreshIntervalCard(minutes: refreshMinutesBinding)
            }

            SettingsSection(title: "Startup") {
                SettingsCard(
                    title: "Launch at login",
                    subtitle: "Open UpworkBuddy automatically when you sign in.",
                    systemImage: "power"
                ) {
                    Toggle("", isOn: $store.launchAtLogin)
                        .labelsHidden()
                        .toggleStyle(.switch)
                        .accessibilityLabel(L10n.t("Launch at login"))
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
}

private struct RefreshIntervalCard: View {
    @Binding var minutes: Int

    private let bounds: ClosedRange<Double> = 1...30

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 2) {
                Text(loc: "Refresh Interval")
                    .font(.system(size: 13.5, weight: .semibold))
                    .foregroundStyle(Theme.textPrimary)
                Text(loc: "How often UpworkBuddy polls for new earnings")
                    .font(.caption)
                    .foregroundStyle(Theme.textTertiary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 14)
            .padding(.vertical, 12)

            Rectangle()
                .fill(Theme.divider)
                .frame(height: 0.5)

            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 10) {
                    Image(systemName: "clock")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.orange)
                    Text(valueLabel)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(Theme.textPrimary)
                        .contentTransition(.numericText())
                        .animation(.snappy, value: minutes)
                }

                Slider(
                    value: Binding(
                        get: { Double(minutes) },
                        set: { minutes = Int($0.rounded()) }
                    ),
                    in: bounds,
                    step: 1
                ) {
                    Text(loc: "Refresh interval")
                } minimumValueLabel: {
                    Text(loc: "1 min")
                        .font(.caption)
                        .foregroundStyle(Theme.textTertiary)
                } maximumValueLabel: {
                    Text(loc: "30 min")
                        .font(.caption)
                        .foregroundStyle(Theme.textTertiary)
                }
                .tint(Theme.accent)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 14)
        }
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Theme.surface.opacity(0.85))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .strokeBorder(Theme.divider, lineWidth: 0.5)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel(L10n.t("Refresh interval"))
        .accessibilityValue(valueLabel)
    }

    private var valueLabel: String {
        minutes == 1 ? L10n.t("1 minute") : L10n.t("%d minutes", minutes)
    }
}

// MARK: - Goals

private struct GoalsPage: View {
    @Bindable var store: AppStore
    @State private var animateGrid = false

    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            GoalsHeroStrip(store: store)

            SettingsSection(
                title: "Targets",
                caption: store.goalsEnabled ? "Tap a value to type directly" : "Enable tracking to edit"
            ) {
                LazyVGrid(
                    columns: [GridItem(.adaptive(minimum: 260), spacing: 12)],
                    spacing: 12
                ) {
                    ForEach(Array(Period.allCases.enumerated()), id: \.element.id) { idx, period in
                        PeriodGoalCard(store: store, period: period)
                            .opacity(displayOpacity(index: idx))
                            .offset(y: animateGrid || !store.goalsEnabled ? 0 : 6)
                    }
                }
                .opacity(store.goalsEnabled ? 1 : 0.45)
                .disabled(!store.goalsEnabled)
                .animation(.smooth(duration: 0.25), value: store.goalsEnabled)
            }

            SettingsSection(
                title: "Notifications",
                caption: "Get notified about usage milestones"
            ) {
                NotificationsCard(store: store)
            }

            SettingsSection(title: "Celebration") {
                SettingsCard(
                    title: "Confetti when a goal is hit",
                    subtitle: "Plays a quick burst when any target reaches 100%.",
                    systemImage: "sparkles"
                ) {
                    Toggle("", isOn: $store.goalCelebrationEnabled)
                        .labelsHidden()
                        .toggleStyle(.switch)
                        .accessibilityLabel(L10n.t("Goal celebration animation"))
                }
            }
        }
        .onAppear { animateGrid = true }
        .onChange(of: store.goalsEnabled) { _, enabled in
            if enabled {
                animateGrid = false
                withAnimation(.smooth(duration: 0.35)) { animateGrid = true }
            }
        }
    }

    private func displayOpacity(index: Int) -> Double {
        // Stagger fade-in when grid first appears or goals re-enabled.
        guard store.goalsEnabled else { return 1 }
        return animateGrid ? 1 : 0
    }
}

private struct GoalsHeroStrip: View {
    @Bindable var store: AppStore
    @State private var notificationStatus: UNAuthorizationStatusWrapper = .unknown

    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Theme.accent.opacity(0.14))
                    .frame(width: 44, height: 44)
                Image(systemName: "target")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Theme.accentDeep)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(loc: "Goal tracking")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Theme.textPrimary)
                Text(loc: "Stay on pace day, week, month, and year. Get a banner when you cross a target.")
                    .font(.system(size: 12))
                    .foregroundStyle(Theme.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
                NotificationStatusChip(status: notificationStatus, enabled: store.goalsEnabled)
                    .padding(.top, 2)
            }
            Spacer(minLength: 8)
            Toggle("", isOn: $store.goalsEnabled)
                .labelsHidden()
                .toggleStyle(.switch)
                .controlSize(.large)
                .accessibilityLabel(L10n.t("Goal tracking"))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(LinearGradient(
                    colors: [Theme.accent.opacity(0.10), Theme.surface.opacity(0.92)],
                    startPoint: .topLeading, endPoint: .bottomTrailing
                ))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .strokeBorder(Theme.accent.opacity(0.25), lineWidth: 0.6)
        )
        .task { await refreshNotificationStatus() }
    }

    private func refreshNotificationStatus() async {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        notificationStatus = .init(rawStatus: settings.authorizationStatus)
    }
}

private enum UNAuthorizationStatusWrapper {
    case unknown
    case authorized
    case denied
    case notDetermined
    case provisional

    init(rawStatus: UNAuthorizationStatus) {
        switch rawStatus {
        case .authorized: self = .authorized
        case .denied: self = .denied
        case .notDetermined: self = .notDetermined
        case .provisional: self = .provisional
        default: self = .unknown
        }
    }
}

private struct NotificationStatusChip: View {
    let status: UNAuthorizationStatusWrapper
    let enabled: Bool

    var body: some View {
        let (label, color, icon) = display
        HStack(spacing: 5) {
            Image(systemName: icon)
                .font(.system(size: 10, weight: .bold))
                .foregroundStyle(color)
            Text(label)
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(Theme.textSecondary)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(label)
    }

    private var display: (String, Color, String) {
        guard enabled else { return (L10n.t("Tracking off"), Theme.textTertiary, "pause.circle.fill") }
        switch status {
        case .authorized, .provisional: return (L10n.t("Notifications on"), Color.green.opacity(0.9), "checkmark.circle.fill")
        case .denied:                   return (L10n.t("Notifications blocked — check System Settings"), Color.orange, "exclamationmark.triangle.fill")
        case .notDetermined:            return (L10n.t("Awaiting permission"), Color.orange.opacity(0.8), "questionmark.circle.fill")
        case .unknown:                  return (L10n.t("Notifications unavailable"), Theme.textTertiary, "xmark.circle.fill")
        }
    }
}

private struct PeriodGoalCard: View {
    @Bindable var store: AppStore
    let period: Period

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            cardHeader

            VStack(spacing: 8) {
                NumericGoalField(
                    icon: "clock",
                    label: L10n.t("Hours"),
                    suffix: "h",
                    value: hoursBinding,
                    range: hoursRange,
                    placeholder: hoursPlaceholder
                )
                NumericGoalField(
                    icon: "dollarsign.circle",
                    label: L10n.t("Earnings"),
                    suffix: store.currency,
                    value: earningsBinding,
                    range: earningsRange,
                    placeholder: earningsPlaceholder
                )
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 11, style: .continuous)
                .fill(Theme.surface.opacity(0.88))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 11, style: .continuous)
                .strokeBorder(Theme.divider, lineWidth: 0.5)
        )
    }

    private var cardHeader: some View {
        HStack(alignment: .center, spacing: 8) {
            Circle().fill(Theme.accent).frame(width: 5, height: 5)
            Text(period.label)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(Theme.textPrimary)
            Spacer()
            if let chip = progressChipText {
                Text(chip)
                    .font(.system(size: 10.5, weight: .medium, design: .monospaced))
                    .foregroundStyle(Theme.textSecondary)
                    .lineLimit(1)
                    .fixedSize(horizontal: true, vertical: false)
                    .padding(.horizontal, 7)
                    .padding(.vertical, 3)
                    .background(
                        Capsule().fill(Theme.chipBg.opacity(0.8))
                    )
            }
        }
    }

    // MARK: bindings

    private var hoursBinding: Binding<Double> {
        switch period {
        case .today: return $store.goalHoursDaily
        case .week:  return $store.goalHoursWeekly
        case .month: return $store.goalHoursMonthly
        case .year:  return $store.goalHoursYearly
        }
    }

    private var earningsBinding: Binding<Double> {
        switch period {
        case .today: return $store.goalEarningsDaily
        case .week:  return $store.goalEarningsWeekly
        case .month: return $store.goalEarningsMonthly
        case .year:  return $store.goalEarningsYearly
        }
    }

    private var hoursRange: ClosedRange<Double> {
        switch period {
        case .today: return 0...24
        case .week:  return 0...168
        case .month: return 0...744
        case .year:  return 0...8760
        }
    }
    private var earningsRange: ClosedRange<Double> {
        switch period {
        case .today: return 0...10000
        case .week:  return 0...50000
        case .month: return 0...200000
        case .year:  return 0...2000000
        }
    }
    private var hoursPlaceholder: String {
        switch period {
        case .today: return "8"
        case .week:  return "40"
        case .month: return "160"
        case .year:  return "2000"
        }
    }
    private var earningsPlaceholder: String {
        switch period {
        case .today: return "500"
        case .week:  return "2500"
        case .month: return "10000"
        case .year:  return "100000"
        }
    }

    // MARK: progress chip

    private var progressChipText: String? {
        let snap: EarningsSnapshot?
        if period == .today {
            snap = store.todaySnapshot
        } else if period == store.selectedPeriod {
            snap = store.snapshot
        } else {
            snap = nil
        }
        guard let snap, store.goalsEnabled else { return nil }

        // Prefer hours chip if hours target set, else earnings.
        let hTarget = hoursBinding.wrappedValue
        let eTarget = earningsBinding.wrappedValue
        if hTarget > 0 {
            let pct = min(999, Int((snap.totalHours / hTarget) * 100))
            return "\(snap.totalHours.asHours()) · \(pct)%"
        } else if eTarget > 0 {
            let f = CurrencyFormat(code: store.currency, masked: false)
            let pct = min(999, Int((snap.totalEarnings / eTarget) * 100))
            return "\(f.compact(snap.totalEarnings)) · \(pct)%"
        } else {
            return nil
        }
    }

}

/// Single-line goal row: icon + label + always-editable text field + suffix.
/// Empty / 0 = "Off". Commits on enter, focus loss, or value change. No
/// stepper, no preset chips — type the number directly.
private struct NumericGoalField: View {
    let icon: String
    let label: String
    let suffix: String
    @Binding var value: Double
    let range: ClosedRange<Double>
    let placeholder: String

    @State private var draft: String = ""
    @FocusState private var focused: Bool

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 11.5, weight: .medium))
                .foregroundStyle(Theme.textTertiary)
                .frame(width: 16)
            Text(label)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(Theme.textSecondary)
                .lineLimit(1)
                .fixedSize(horizontal: true, vertical: false)
            Spacer(minLength: 6)

            HStack(spacing: 5) {
                TextField(placeholder, text: $draft)
                    .textFieldStyle(.plain)
                    .multilineTextAlignment(.trailing)
                    .font(.system(size: 13, weight: .semibold, design: .monospaced))
                    .foregroundStyle(value > 0 ? Theme.textPrimary : Theme.textTertiary)
                    .frame(width: 60)
                    .focused($focused)
                    .onSubmit(commit)
                    .onExitCommand { focused = false }
                    .onChange(of: focused) { _, isFocused in
                        if !isFocused { commit() }
                    }
                    .accessibilityLabel("\(label) \(L10n.t("target"))")

                if !suffix.isEmpty {
                    Text(suffix)
                        .font(.system(size: 11.5, weight: .medium))
                        .foregroundStyle(Theme.textTertiary)
                        .lineLimit(1)
                        .fixedSize(horizontal: true, vertical: false)
                }
            }
            .fixedSize(horizontal: true, vertical: false)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 7, style: .continuous)
                    .fill(Theme.chipBg.opacity(focused ? 0.5 : 0.6))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 7, style: .continuous)
                    .strokeBorder(focused ? Theme.accent : Theme.divider,
                                  lineWidth: focused ? 1.2 : 0.5)
            )
        }
        .onAppear(perform: syncDraft)
        .onChange(of: value) { _, _ in
            if !focused { syncDraft() }
        }
    }

    private func syncDraft() {
        draft = value > 0 ? formatNumber(value) : ""
    }

    private func formatNumber(_ v: Double) -> String {
        if v == v.rounded() { return "\(Int(v))" }
        return String(format: "%.1f", v)
    }

    private func commit() {
        let cleaned = draft
            .replacingOccurrences(of: ",", with: "")
            .replacingOccurrences(of: "$", with: "")
            .replacingOccurrences(of: " ", with: "")
            .trimmingCharacters(in: .whitespaces)

        if cleaned.isEmpty {
            value = 0
            draft = ""
            return
        }
        if let parsed = Double(cleaned) {
            value = min(range.upperBound, max(range.lowerBound, parsed))
        }
        syncDraft()
    }
}

// MARK: - Notifications card

private struct NotificationsCard: View {
    @Bindable var store: AppStore
    @State private var customDraft: String = ""
    @FocusState private var customFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            masterRow
            Divider().background(Theme.divider.opacity(0.4))
            thresholdsBlock
                .opacity(store.progressNotificationsEnabled ? 1 : 0.45)
                .disabled(!store.progressNotificationsEnabled)
            Divider().background(Theme.divider.opacity(0.4))
            customBlock
                .opacity(store.progressNotificationsEnabled ? 1 : 0.45)
                .disabled(!store.progressNotificationsEnabled)
            Divider().background(Theme.divider.opacity(0.4))
            soundRow
        }
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Theme.surface.opacity(0.85))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .strokeBorder(Theme.divider, lineWidth: 0.5)
        )
        .animation(.smooth(duration: 0.22), value: store.progressNotificationsEnabled)
    }

    private var masterRow: some View {
        HStack(alignment: .center, spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(Theme.accent.opacity(0.14))
                    .frame(width: 32, height: 32)
                Image(systemName: "bell.badge")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Theme.accentDeep)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(loc: "Enable notifications")
                    .font(.system(size: 13.5, weight: .semibold))
                    .foregroundStyle(Theme.textPrimary)
                Text(loc: "Receive alerts when approaching usage limits")
                    .font(.system(size: 11.5))
                    .foregroundStyle(Theme.textSecondary)
            }
            Spacer(minLength: 8)
            Toggle("", isOn: $store.progressNotificationsEnabled)
                .labelsHidden()
                .toggleStyle(.switch)
                .accessibilityLabel(L10n.t("Enable progress notifications"))
        }
        .padding(14)
    }

    private var thresholdsBlock: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(loc: "Alert Thresholds")
                .font(.system(size: 11.5, weight: .medium))
                .foregroundStyle(Theme.textSecondary)

            VStack(spacing: 8) {
                ForEach(store.knownThresholds, id: \.self) { pct in
                    ThresholdRow(
                        percent: pct,
                        label: thresholdLabel(for: pct),
                        color: thresholdColor(for: pct),
                        isOn: Binding(
                            get: { store.enabledThresholds.contains(pct) },
                            set: { store.setThreshold(pct, enabled: $0) }
                        ),
                        canRemove: !AppStore.defaultThresholds.contains(pct),
                        onRemove: { store.removeCustomThreshold(pct) }
                    )
                }
                ThresholdRow(
                    percent: 0,
                    label: L10n.t("Session Reset"),
                    color: Color.green.opacity(0.8),
                    isOn: $store.notifyOnSessionReset,
                    canRemove: false,
                    onRemove: {}
                )
            }
        }
        .padding(14)
    }

    private var customBlock: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(loc: "Custom Thresholds")
                .font(.system(size: 11.5, weight: .medium))
                .foregroundStyle(Theme.textSecondary)
            HStack(spacing: 8) {
                TextField("", text: $customDraft, prompt: Text(loc: "e.g. 50"))
                    .textFieldStyle(.plain)
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 13, weight: .semibold, design: .monospaced))
                    .foregroundStyle(Theme.textPrimary)
                    .frame(width: 70)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 7, style: .continuous)
                            .fill(Theme.chipBg.opacity(customFocused ? 0.5 : 0.6))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 7, style: .continuous)
                            .strokeBorder(customFocused ? Theme.accent : Theme.divider,
                                          lineWidth: customFocused ? 1.2 : 0.5)
                    )
                    .focused($customFocused)
                    .onSubmit(commitCustom)
                    .accessibilityLabel(L10n.t("Custom threshold percent"))
                Text(verbatim: "%")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Theme.textTertiary)
                Button(L10n.t("Add"), action: commitCustom)
                    .buttonStyle(.borderedProminent)
                    .controlSize(.small)
                    .tint(Theme.accent)
                    .disabled(parsedCustom == nil)
                Spacer()
            }
        }
        .padding(14)
    }

    private var soundRow: some View {
        HStack(spacing: 10) {
            Image(systemName: store.notificationSoundEnabled ? "speaker.wave.2.fill" : "speaker.slash.fill")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(store.notificationSoundEnabled ? Theme.accent : Theme.textTertiary)
                .frame(width: 18)
            Text(loc: "Sound")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(Theme.textPrimary)
            Spacer()
            Toggle("", isOn: $store.notificationSoundEnabled)
                .labelsHidden()
                .toggleStyle(.switch)
                .accessibilityLabel(L10n.t("Notification sound"))
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
    }

    private var parsedCustom: Int? {
        let trimmed = customDraft.trimmingCharacters(in: .whitespaces)
            .replacingOccurrences(of: "%", with: "")
        guard let n = Int(trimmed), (1...99).contains(n) else { return nil }
        return n
    }

    private func commitCustom() {
        guard let pct = parsedCustom else { return }
        store.addCustomThreshold(pct)
        customDraft = ""
    }

    private func thresholdLabel(for pct: Int) -> String {
        switch pct {
        case ..<80:  return L10n.t("Warning")
        case 80..<95: return L10n.t("High Usage")
        case 95...:   return L10n.t("Critical")
        default:      return L10n.t("Milestone")
        }
    }

    private func thresholdColor(for pct: Int) -> Color {
        switch pct {
        case ..<80:  return Color.yellow.opacity(0.9)
        case 80..<95: return Color.orange
        case 95...:   return Color.red.opacity(0.9)
        default:      return Theme.accent
        }
    }
}

private struct ThresholdRow: View {
    let percent: Int     // 0 == session reset
    let label: String
    let color: Color
    @Binding var isOn: Bool
    let canRemove: Bool
    let onRemove: () -> Void

    var body: some View {
        HStack(spacing: 10) {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
            Text("\(percent)%")
                .font(.system(size: 12.5, weight: .semibold, design: .monospaced))
                .foregroundStyle(Theme.textPrimary)
                .frame(minWidth: 38, alignment: .leading)
            Text(label)
                .font(.system(size: 12.5))
                .foregroundStyle(Theme.textSecondary)
            Spacer(minLength: 6)
            if canRemove {
                Button(action: onRemove) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 13))
                        .foregroundStyle(Theme.textTertiary)
                }
                .buttonStyle(.plain)
                .help(L10n.t("Remove custom threshold"))
                .accessibilityLabel(L10n.t("Remove %d percent threshold", percent))
            }
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .toggleStyle(.switch)
                .controlSize(.mini)
                .accessibilityLabel(L10n.t("%@ at %d percent", label, percent))
        }
    }
}

// MARK: - Display

private struct DisplayPage: View {
    @Bindable var store: AppStore

    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            SettingsSection(
                title: "Theme",
                caption: "Used across dashboard, menu bar, and settings"
            ) {
                HStack(spacing: 14) {
                    ForEach(AppTheme.allCases) { theme in
                        ThemeSwatch(theme: theme, isSelected: store.appTheme == theme)
                            .onTapGesture {
                                withAnimation(.smooth(duration: 0.25)) {
                                    store.appTheme = theme
                                }
                            }
                            .accessibilityLabel(L10n.t("%@ theme", theme.label))
                            .accessibilityAddTraits(store.appTheme == theme ? .isSelected : [])
                    }
                    Spacer()
                }
                .padding(.vertical, 4)
                .padding(.leading, 4)
            }

            MenuBarMetricsSection(store: store)

            SettingsSection(title: "Dashboard") {
                SettingsCard(
                    title: "Primary metric",
                    subtitle: "Renders large in the popover header.",
                    systemImage: "textformat.size.larger"
                ) {
                    Picker("", selection: $store.dashboardMetric) {
                        Text(loc: "Earnings").tag(MenuBarMetric.earnings)
                        Text(loc: "Hours").tag(MenuBarMetric.hours)
                    }
                    .pickerStyle(.segmented)
                    .labelsHidden()
                    .frame(maxWidth: 220)
                }

                SettingsCard(
                    title: "Hide sensitive amounts",
                    subtitle: "Masks earnings, rates, and totals across the app.",
                    systemImage: "eye.slash"
                ) {
                    Toggle("", isOn: $store.hideSensitive)
                        .labelsHidden()
                        .toggleStyle(.switch)
                        .accessibilityLabel(L10n.t("Hide sensitive amounts"))
                }
            }

            SettingsSection(title: "Currency") {
                SettingsCard(
                    title: "Display currency",
                    subtitle: "FX support coming in v2.",
                    systemImage: "dollarsign.circle"
                ) {
                    HStack(spacing: 8) {
                        Text(store.currency)
                            .font(.system(size: 12, weight: .semibold, design: .monospaced))
                            .foregroundStyle(Theme.textPrimary)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(
                                Capsule().fill(Theme.chipBg.opacity(0.7))
                            )
                        Text(loc: "Coming soon")
                            .font(.caption.italic())
                            .foregroundStyle(Theme.textTertiary)
                    }
                }
            }
        }
    }
}

// MARK: - Shortcuts

private struct ShortcutsPage: View {
    @Environment(AppStore.self) private var store

    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            SettingsSection(title: "Bindings", caption: "Esc cancels recording") {
                VStack(spacing: 10) {
                    ForEach(ShortcutAction.allCases) { action in
                        ShortcutRow(action: action, store: store)
                    }
                }
            }

            HStack(alignment: .top, spacing: 12) {
                Image(systemName: "info.circle.fill")
                    .font(.system(size: 14))
                    .foregroundStyle(Theme.accentDeep)
                VStack(alignment: .leading, spacing: 4) {
                    Text(loc: "Global shortcuts")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Theme.textPrimary)
                    Text(loc: "Shortcuts work from any application. Each shortcut must include at least one modifier key (⌘, ⌥, ⌃, or ⇧).")
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
            systemImage: action.systemImage,
            trailingMinWidth: 240
        ) {
            HStack(spacing: 8) {
                ShortcutRecorder(
                    shortcut: store.shortcuts[action] ?? nil,
                    onCapture: { store.setShortcut($0, for: action) },
                    onClear:   { store.setShortcut(nil, for: action) }
                )
                Button(L10n.t("Reset")) {
                    store.resetShortcut(for: action)
                }
                .buttonStyle(.borderless)
                .font(.caption)
                .foregroundStyle(Theme.textTertiary)
            }
        }
    }
}

// MARK: - Account

private struct AccountPage: View {
    @Bindable var store: AppStore
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            SettingsSection(title: "Connection") {
                SettingsCard(
                    title: "Upwork",
                    subtitle: store.isAuthenticated ? "Signed in via OAuth." : "Not connected.",
                    systemImage: "link.circle.fill"
                ) {
                    HStack(spacing: 8) {
                        Circle()
                            .fill(store.isAuthenticated ? Color.green : Color.gray)
                            .frame(width: 8, height: 8)
                        Text(loc: store.isAuthenticated ? "Connected" : "Disconnected")
                            .font(.system(size: 12.5, weight: .medium))
                            .foregroundStyle(Theme.textPrimary)
                    }
                }
            }

            SettingsSection(title: "Danger zone") {
                SettingsCard(
                    title: "Disconnect",
                    subtitle: "Sign out and clear cached earnings on this Mac.",
                    systemImage: "rectangle.portrait.and.arrow.right",
                    trailingMinWidth: 180
                ) {
                    Button(role: .destructive) {
                        Task { await store.logout() }
                    } label: {
                        Label {
                            Text(loc: "Disconnect")
                        } icon: {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                        }
                    }
                    .controlSize(.regular)
                }
            }
        }
    }
}

// MARK: - Menu Bar Metrics

private struct MenuBarMetricsSection: View {
    @Bindable var store: AppStore

    var body: some View {
        SettingsSection(
            title: "Menu bar",
            caption: "Choose which targets surface in the status bar"
        ) {
        VStack(alignment: .leading, spacing: 12) {
            MenuBarMetricCard(
                title: "Today target",
                subtitle: "Daily progress in the menu bar",
                systemImage: "clock.fill",
                enabled: $store.todayMetricEnabled,
                style: $store.todayMetricStyle,
                displayMode: nil,
                sampleProgress: todayProgress,
                sampleLabel: todayLabel(for: store.todayMetricStyle, mode: .percentage)
            )

            MenuBarMetricCard(
                title: "Weekly target",
                subtitle: "Weekly progress in the menu bar",
                systemImage: "calendar",
                enabled: $store.weekMetricEnabled,
                style: $store.weekMetricStyle,
                displayMode: $store.weekMetricMode,
                sampleProgress: weekProgress,
                sampleLabel: weekLabel(for: store.weekMetricStyle, mode: store.weekMetricMode)
            )
        }
        }
    }

    // MARK: - Sample data

    private var todayProgress: Double {
        progress(snapshot: store.todaySnapshot, period: .today)
    }

    private var weekProgress: Double {
        progress(snapshot: store.weekSnapshot, period: .week)
    }

    private func progress(snapshot: EarningsSnapshot, period: Period) -> Double {
        let target = store.goalTarget(for: .hours, period: period)
        if target > 0 { return snapshot.totalHours / target }
        let earnTarget = store.goalTarget(for: .earnings, period: period)
        if earnTarget > 0 { return snapshot.totalEarnings / earnTarget }
        return 0.6   // sample fill so previews still illustrate the style
    }

    private func todayLabel(for style: MenuBarMetricStyle, mode: MenuBarDisplayMode) -> String {
        previewLabel(snapshot: store.todaySnapshot, period: .today, style: style, mode: mode, periodCaption: "Today")
    }

    private func weekLabel(for style: MenuBarMetricStyle, mode: MenuBarDisplayMode) -> String {
        previewLabel(snapshot: store.weekSnapshot, period: .week, style: style, mode: mode, periodCaption: "Week")
    }

    private func previewLabel(snapshot: EarningsSnapshot,
                              period: Period,
                              style: MenuBarMetricStyle,
                              mode: MenuBarDisplayMode,
                              periodCaption: String) -> String {
        switch style {
        case .batteryClassic: return periodCaption
        case .progressBar, .compact: return ""
        case .percentage, .iconWithBar:
            return MenuBarMetricFormatter.label(
                snapshot: snapshot,
                period: period,
                store: store,
                mode: mode
            )
        }
    }
}

private struct MenuBarMetricCard: View {
    let title: String
    let subtitle: String
    let systemImage: String
    @Binding var enabled: Bool
    @Binding var style: MenuBarMetricStyle
    let displayMode: Binding<MenuBarDisplayMode>?
    let sampleProgress: Double
    let sampleLabel: String

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            cardHeader
            if enabled {
                Divider().background(Theme.divider.opacity(0.4))
                iconStylePicker
                if let displayMode {
                    Divider().background(Theme.divider.opacity(0.4))
                    DisplayModePicker(selection: displayMode)
                        .padding(14)
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Theme.surface.opacity(0.85))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .strokeBorder(
                    enabled ? Theme.accent.opacity(0.35) : Theme.divider,
                    lineWidth: enabled ? 0.8 : 0.5
                )
        )
        .animation(.smooth(duration: 0.22), value: enabled)
    }

    private var cardHeader: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(Theme.accent.opacity(0.14))
                    .frame(width: 32, height: 32)
                Image(systemName: systemImage)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Theme.accentDeep)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(L10n.t(title))
                    .font(.system(size: 13.5, weight: .semibold))
                    .foregroundStyle(Theme.textPrimary)
                Text(L10n.t(subtitle))
                    .font(.system(size: 11.5))
                    .foregroundStyle(Theme.textSecondary)
            }
            Spacer(minLength: 8)
            Toggle("", isOn: $enabled)
                .labelsHidden()
                .toggleStyle(.switch)
        }
        .padding(14)
    }

    private var iconStylePicker: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(loc: "Icon Style")
                .font(.system(size: 11.5, weight: .medium))
                .foregroundStyle(Theme.textSecondary)
            HStack(spacing: 10) {
                ForEach(MenuBarMetricStyle.allCases) { option in
                    MenuBarStylePickerTile(
                        style: option,
                        isSelected: style == option,
                        sampleProgress: sampleProgress,
                        sampleLabel: tileSampleLabel(for: option),
                        action: { style = option }
                    )
                }
            }
        }
        .padding(14)
    }

    private func tileSampleLabel(for option: MenuBarMetricStyle) -> String {
        switch option {
        case .batteryClassic:
            // English "Week"/"Today" still works because `title` is the
            // English source key passed in by the call site.
            return title.contains("Week") ? L10n.t("Week") : L10n.t("Today")
        case .percentage:     return "60%"
        case .iconWithBar, .compact, .progressBar: return ""
        }
    }
}

private struct DisplayModePicker: View {
    @Binding var selection: MenuBarDisplayMode

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(loc: "Display Mode")
                .font(.system(size: 11.5, weight: .medium))
                .foregroundStyle(Theme.textSecondary)

            VStack(alignment: .leading, spacing: 8) {
                ForEach(MenuBarDisplayMode.allCases) { mode in
                    DisplayModeRow(
                        mode: mode,
                        isSelected: selection == mode,
                        action: { selection = mode }
                    )
                }
            }
        }
    }
}

private struct DisplayModeRow: View {
    let mode: MenuBarDisplayMode
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(alignment: .top, spacing: 10) {
                ZStack {
                    Circle()
                        .strokeBorder(isSelected ? Theme.accent : Theme.divider,
                                      lineWidth: isSelected ? 1.4 : 1)
                        .frame(width: 14, height: 14)
                    if isSelected {
                        Circle()
                            .fill(Theme.accent)
                            .frame(width: 7, height: 7)
                    }
                }
                .padding(.top, 2)

                VStack(alignment: .leading, spacing: 2) {
                    Text(L10n.t(mode.label))
                        .font(.system(size: 12.5, weight: isSelected ? .semibold : .medium))
                        .foregroundStyle(Theme.textPrimary)
                    Text(L10n.t(mode.subtitle))
                        .font(.system(size: 11))
                        .foregroundStyle(Theme.textSecondary)
                }
                Spacer(minLength: 0)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - ThemeSwatch

private struct ThemeSwatch: View {
    let theme: AppTheme
    let isSelected: Bool

    var body: some View {
        let palette = theme.palette
        VStack(spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(LinearGradient(colors: [palette.bgTop, palette.bgBottom],
                                         startPoint: .top, endPoint: .bottom))
                HStack(spacing: 5) {
                    Circle().fill(palette.accent).frame(width: 12, height: 12)
                    Circle().fill(palette.accentDeep).frame(width: 12, height: 12)
                    Circle().fill(palette.accentSoft).frame(width: 12, height: 12)
                }
            }
            .frame(width: 96, height: 54)
            .overlay(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .strokeBorder(isSelected ? palette.accent : palette.divider,
                                  lineWidth: isSelected ? 1.6 : 0.5)
            )
            .scaleEffect(isSelected ? 1.04 : 1)
            .shadow(color: isSelected ? palette.accent.opacity(0.18) : .clear, radius: 6, y: 2)

            Text(L10n.t(theme.label))
                .font(.system(size: 11.5, weight: isSelected ? .semibold : .regular))
                .foregroundStyle(Theme.textSecondary)
        }
        .contentShape(Rectangle())
    }
}
