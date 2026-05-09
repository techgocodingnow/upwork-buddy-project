import SwiftUI
import AppKit
import UserNotifications

// MARK: - Categories

enum SettingsCategory: String, CaseIterable, Identifiable, Hashable {
    case general
    case goals
    case display
    case shortcuts
    case account

    var id: String { rawValue }

    var label: String {
        switch self {
        case .general:   return "General"
        case .goals:     return "Goals"
        case .display:   return "Display"
        case .shortcuts: return "Shortcuts"
        case .account:   return "Account"
        }
    }

    var subtitle: String {
        switch self {
        case .general:   return "Refresh cadence and login behavior"
        case .goals:     return "Hours and earnings targets, with notifications"
        case .display:   return "Theme, menu bar, and dashboard"
        case .shortcuts: return "Global keyboard shortcuts"
        case .account:   return "Connected Upwork session"
        }
    }

    var systemImage: String {
        switch self {
        case .general:   return "gearshape"
        case .goals:     return "target"
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
                .frame(width: 212)
            Divider().background(Theme.divider)
            SettingsContent(category: selection)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(Theme.bgGradient.ignoresSafeArea())
        .frame(minWidth: 680, minHeight: 520)
        .id(store.appTheme)
        .background {
            // Hidden command pads register ⌘1…⌘5 for sidebar jumps.
            ForEach(Array(SettingsCategory.allCases.enumerated()), id: \.element.id) { idx, cat in
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

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            brandHeader
            Divider().background(Theme.divider.opacity(0.5))

            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    sidebarGroup(title: "Settings", items: SettingsCategory.allCases)
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
                    .foregroundStyle(Theme.accent)
            }
            VStack(alignment: .leading, spacing: 0) {
                Text("UpworkBuddy")
                    .font(.system(size: 13.5, weight: .semibold))
                    .foregroundStyle(Theme.textPrimary)
                Text("Settings")
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
                Text(title.uppercased())
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
        HStack(spacing: 4) {
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
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
    }
}

private struct SidebarRow: View {
    let label: String
    let systemImage: String
    let keyHint: String
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
                Text(keyHint)
                    .font(.system(size: 10, weight: .medium, design: .monospaced))
                    .foregroundStyle(isSelected ? Color.white.opacity(0.85) : Theme.textTertiary.opacity(hovering ? 0.85 : 0))
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
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(hovering ? Theme.accent : Theme.textTertiary)
                .frame(width: 24, height: 24)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .onHover { hovering = $0 }
        .help(help)
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
                    case .general:   GeneralPage(store: store)
                    case .goals:     GoalsPage(store: store)
                    case .display:   DisplayPage(store: store)
                    case .shortcuts: ShortcutsPage()
                    case .account:   AccountPage(store: store)
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
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Rectangle().fill(Theme.accent).frame(width: 18, height: 1.5)
                Text(category.label.uppercased())
                    .font(.system(size: 10.5, weight: .semibold))
                    .tracking(1.4)
                    .foregroundStyle(Theme.accent)
            }
            Text(category.label)
                .font(.system(size: 26, weight: .bold))
                .tracking(-0.5)
                .foregroundStyle(Theme.textPrimary)
            Text(category.subtitle)
                .font(.system(size: 13))
                .foregroundStyle(Theme.textSecondary)
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
                Text(title.uppercased())
                    .font(.system(size: 10, weight: .semibold))
                    .tracking(1.2)
                    .foregroundStyle(Theme.textTertiary)
                Rectangle().fill(Theme.divider).frame(height: 1)
                if let caption {
                    Text(caption)
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
    var trailingMinWidth: CGFloat = 220
    @ViewBuilder let content: () -> Content

    var body: some View {
        HStack(alignment: .center, spacing: 14) {
            if let systemImage {
                Image(systemName: systemImage)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Theme.accent)
                    .frame(width: 28, height: 28)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Theme.accent.opacity(0.12))
                    )
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 13.5, weight: .semibold))
                    .foregroundStyle(Theme.textPrimary)
                if let subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(Theme.textTertiary)
                }
            }
            Spacer(minLength: 8)
            content()
                .frame(minWidth: trailingMinWidth, alignment: .trailing)
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
}

// MARK: - General

private struct GeneralPage: View {
    @Bindable var store: AppStore

    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            SettingsSection(title: "Sync") {
                SettingsCard(
                    title: "Refresh interval",
                    subtitle: "How often UpworkBuddy polls for new earnings.",
                    systemImage: "arrow.clockwise"
                ) {
                    RefreshPillRow(
                        selection: refreshMinutesBinding,
                        options: [1, 5, 15, 30]
                    )
                }
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

private struct RefreshPillRow: View {
    @Binding var selection: Int
    let options: [Int]

    var body: some View {
        HStack(spacing: 6) {
            ForEach(options, id: \.self) { value in
                Button {
                    selection = value
                } label: {
                    Text("\(value) min")
                        .font(.system(size: 12, weight: selection == value ? .semibold : .medium))
                        .foregroundStyle(selection == value ? Color.white : Theme.textSecondary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 7, style: .continuous)
                                .fill(selection == value ? Theme.accent : Theme.chipBg.opacity(0.6))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 7, style: .continuous)
                                .strokeBorder(Theme.divider.opacity(selection == value ? 0 : 1),
                                              lineWidth: 0.5)
                        )
                }
                .buttonStyle(.plain)
            }
        }
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
                    columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)],
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
                    .foregroundStyle(Theme.accent)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text("Goal tracking")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Theme.textPrimary)
                Text("Stay on pace day, week, month, and year. Get a banner when you cross a target.")
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
        let (label, color) = display
        HStack(spacing: 5) {
            Circle().fill(color).frame(width: 6, height: 6)
            Text(label)
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(Theme.textSecondary)
        }
    }

    private var display: (String, Color) {
        guard enabled else { return ("Tracking off", Theme.textTertiary) }
        switch status {
        case .authorized, .provisional: return ("Notifications on", Color.green.opacity(0.85))
        case .denied:                   return ("Notifications blocked — check System Settings", Color.orange)
        case .notDetermined:            return ("Awaiting permission", Color.orange.opacity(0.8))
        case .unknown:                  return ("Notifications unavailable", Theme.textTertiary)
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
                    label: "Hours",
                    suffix: "h",
                    value: hoursBinding,
                    range: hoursRange,
                    step: hoursStep,
                    formatter: { hoursLabel($0) },
                    presets: hoursPresets
                )
                NumericGoalField(
                    icon: "dollarsign.circle",
                    label: "Earnings",
                    suffix: "",
                    value: earningsBinding,
                    range: earningsRange,
                    step: earningsStep,
                    formatter: { earningsLabel($0) },
                    presets: earningsPresets
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
    private var hoursStep: Double {
        switch period {
        case .today: return 0.5
        case .week:  return 1
        case .month: return 5
        case .year:  return 25
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
    private var earningsStep: Double {
        switch period {
        case .today: return 25
        case .week:  return 100
        case .month: return 500
        case .year:  return 1000
        }
    }
    private var hoursPresets: [Double] {
        switch period {
        case .today: return [4, 6, 8]
        case .week:  return [20, 30, 40]
        case .month: return [80, 120, 160]
        case .year:  return [1000, 1500, 2000]
        }
    }
    private var earningsPresets: [Double] {
        switch period {
        case .today: return [200, 500, 1000]
        case .week:  return [1000, 2500, 5000]
        case .month: return [5000, 10000, 20000]
        case .year:  return [50000, 100000, 200000]
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

    // MARK: labels

    private func hoursLabel(_ hours: Double) -> String {
        if hours <= 0 { return "Off" }
        let whole = Int(hours)
        let frac = hours - Double(whole)
        if frac < 0.05 { return "\(whole) h" }
        return String(format: "%.1f h", hours)
    }

    private func earningsLabel(_ amount: Double) -> String {
        if amount <= 0 { return "Off" }
        return CurrencyFormat(code: store.currency, masked: false).compact(amount)
    }
}

private struct NumericGoalField: View {
    let icon: String
    let label: String
    let suffix: String
    @Binding var value: Double
    let range: ClosedRange<Double>
    let step: Double
    let formatter: (Double) -> String
    let presets: [Double]

    @State private var editing = false
    @State private var draftText = ""
    @FocusState private var focused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(Theme.textTertiary)
                    .frame(width: 14)
                Text(label)
                    .font(.system(size: 11.5, weight: .medium))
                    .foregroundStyle(Theme.textSecondary)
                Spacer()

                if editing {
                    TextField("", text: $draftText, onCommit: commitDraft)
                        .textFieldStyle(.plain)
                        .font(.system(size: 12.5, weight: .medium, design: .monospaced))
                        .multilineTextAlignment(.trailing)
                        .frame(width: 80)
                        .focused($focused)
                        .onSubmit(commitDraft)
                        .onExitCommand { editing = false }
                } else {
                    Button {
                        draftText = formatDraft(value)
                        editing = true
                        DispatchQueue.main.async { focused = true }
                    } label: {
                        Text(formatter(value))
                            .font(.system(size: 12.5, weight: .semibold, design: .monospaced))
                            .foregroundStyle(value > 0 ? Theme.textPrimary : Theme.textTertiary)
                            .frame(minWidth: 60, alignment: .trailing)
                    }
                    .buttonStyle(.plain)
                    .help("Click to type a value")
                }

                stepperButtons
            }

            HStack(spacing: 6) {
                ForEach(presets, id: \.self) { preset in
                    Button {
                        value = preset
                    } label: {
                        Text(formatPreset(preset))
                            .font(.system(size: 10.5, weight: .medium, design: .monospaced))
                            .foregroundStyle(value == preset ? Color.white : Theme.textSecondary)
                            .padding(.horizontal, 7)
                            .padding(.vertical, 3)
                            .background(
                                Capsule().fill(value == preset ? Theme.accent : Theme.chipBg.opacity(0.7))
                            )
                    }
                    .buttonStyle(.plain)
                }
                if value > 0 {
                    Button {
                        value = 0
                    } label: {
                        Text("Off")
                            .font(.system(size: 10.5, weight: .medium))
                            .foregroundStyle(Theme.textTertiary)
                            .padding(.horizontal, 7)
                            .padding(.vertical, 3)
                            .background(
                                Capsule().strokeBorder(Theme.divider, lineWidth: 0.5)
                            )
                    }
                    .buttonStyle(.plain)
                    .help("Clear this target")
                }
                Spacer()
            }
            .opacity(0.95)
        }
    }

    private var stepperButtons: some View {
        HStack(spacing: 2) {
            stepperButton(systemName: "minus") {
                value = max(range.lowerBound, value - step)
            }
            stepperButton(systemName: "plus") {
                value = min(range.upperBound, value + step)
            }
        }
    }

    private func stepperButton(systemName: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 9, weight: .bold))
                .foregroundStyle(Theme.textSecondary)
                .frame(width: 18, height: 18)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Theme.chipBg.opacity(0.7))
                )
        }
        .buttonStyle(.plain)
    }

    private func formatDraft(_ v: Double) -> String {
        if v <= 0 { return "" }
        let frac = v - Double(Int(v))
        if frac < 0.05 { return "\(Int(v))" }
        return String(format: "%.2f", v)
    }

    private func formatPreset(_ p: Double) -> String {
        if p >= 1000 {
            let k = p / 1000
            if k == k.rounded() {
                return "\(Int(k))k\(suffix)"
            }
            return String(format: "%.1fk%@", k, suffix)
        }
        if p == p.rounded() {
            return "\(Int(p))\(suffix)"
        }
        return String(format: "%.1f%@", p, suffix)
    }

    private func commitDraft() {
        let trimmed = draftText
            .replacingOccurrences(of: ",", with: "")
            .replacingOccurrences(of: "$", with: "")
            .trimmingCharacters(in: .whitespaces)
        if trimmed.isEmpty {
            value = 0
        } else if let parsed = Double(trimmed) {
            value = min(range.upperBound, max(range.lowerBound, parsed))
        }
        editing = false
    }
}

// MARK: - Display

private struct DisplayPage: View {
    @Bindable var store: AppStore

    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            SettingsSection(title: "Theme") {
                SettingsCard(
                    title: "Color palette",
                    subtitle: "Used across dashboard, menu bar, and settings.",
                    systemImage: "paintpalette",
                    trailingMinWidth: 0
                ) {
                    EmptyView()
                }
                HStack(spacing: 14) {
                    ForEach(AppTheme.allCases) { theme in
                        ThemeSwatch(theme: theme, isSelected: store.appTheme == theme)
                            .onTapGesture {
                                withAnimation(.smooth(duration: 0.25)) {
                                    store.appTheme = theme
                                }
                            }
                    }
                    Spacer()
                }
                .padding(.leading, 4)
            }

            SettingsSection(title: "Menu bar") {
                SettingsCard(
                    title: "Shows",
                    subtitle: "Which value appears next to the icon.",
                    systemImage: "menubar.rectangle"
                ) {
                    Picker("", selection: $store.menuBarMetric) {
                        Text("Hours").tag(MenuBarMetric.hours)
                        Text("Earnings").tag(MenuBarMetric.earnings)
                    }
                    .pickerStyle(.segmented)
                    .labelsHidden()
                    .frame(maxWidth: 220)
                }

                SettingsCard(
                    title: "Style",
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
                    .frame(maxWidth: 260)
                }
            }

            SettingsSection(title: "Dashboard") {
                SettingsCard(
                    title: "Primary metric",
                    subtitle: "Renders large in the popover header.",
                    systemImage: "textformat.size.larger"
                ) {
                    Picker("", selection: $store.dashboardMetric) {
                        Text("Earnings").tag(MenuBarMetric.earnings)
                        Text("Hours").tag(MenuBarMetric.hours)
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
                        Text("Coming soon")
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
                    .foregroundStyle(Theme.accent)
                VStack(alignment: .leading, spacing: 4) {
                    Text("Global shortcuts")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Theme.textPrimary)
                    Text("Shortcuts work from any application. Each shortcut must include at least one modifier key (⌘, ⌥, ⌃, or ⇧).")
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
                        Text(store.isAuthenticated ? "Connected" : "Disconnected")
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
                        Label("Disconnect", systemImage: "rectangle.portrait.and.arrow.right")
                    }
                    .controlSize(.regular)
                }
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

            Text(theme.label)
                .font(.system(size: 11.5, weight: isSelected ? .semibold : .regular))
                .foregroundStyle(Theme.textSecondary)
        }
        .contentShape(Rectangle())
    }
}
