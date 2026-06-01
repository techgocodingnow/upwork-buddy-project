import Foundation
import Observation
import SwiftUI

enum MenuBarMetric: String, CaseIterable, Sendable {
    case hours
    case earnings
}

/// Visual style for the goal-celebration overlay. Each case renders with a
/// distinct particle trajectory in `ConfettiView`.
enum CelebrationStyle: String, CaseIterable, Sendable, Identifiable {
    // All styles render through Vortex (twostraws/Vortex, MIT). Each maps to
    // either a built-in preset or a small custom VortexSystem.
    case fireworks
    case confettiRain
    case moneyRain
    case snow
    case rain

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .fireworks:    return "Fireworks 🎆"
        case .confettiRain: return "Confetti burst 🎊"
        case .moneyRain:    return "Money rain 💵"
        case .snow:         return "Snow ❄️"
        case .rain:         return "Rain 🌧️"
        }
    }
}

/// Audio cue played alongside the celebration overlay. `.off` mutes it;
/// `.custom` plays a user-supplied local file or remote URL via
/// `CelebrationSoundPlayer` — no bundled audio assets.
enum CelebrationSound: String, CaseIterable, Sendable, Identifiable {
    case off
    // User-supplied audio (local file path or remote URL persisted in
    // AppStore.customSoundSource).
    case custom    = "custom"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .off:       return "Off"
        case .custom:    return "Custom…"
        }
    }
}

/// Wrapper that lets us encode an `Optional<Shortcut>` inside a JSON dictionary.
struct ShortcutCodable: Codable, Sendable {
    let shortcut: Shortcut?
}

enum MenuBarIconStyle: String, CaseIterable, Sendable {
    case iconValue   // SF symbol + value (default)
    case iconOnly    // symbol only
    case valueOnly   // value only

    var label: String {
        switch self {
        case .iconValue: return L10n.t("Icon + value")
        case .iconOnly:  return L10n.t("Icon only")
        case .valueOnly: return L10n.t("Value only")
        }
    }
}

/// Visual style for a single menu-bar metric (today or weekly).
enum MenuBarMetricStyle: String, CaseIterable, Sendable, Identifiable {
    case batteryClassic
    case progressBar
    case percentage
    case iconWithBar
    case compact

    var id: String { rawValue }

    var label: String {
        switch self {
        case .batteryClassic: return L10n.t("Battery (Classic)")
        case .progressBar:    return L10n.t("Progress Bar")
        case .percentage:     return L10n.t("Percentage")
        case .iconWithBar:    return L10n.t("Icon with Bar")
        case .compact:        return L10n.t("Compact")
        }
    }
}

/// User-facing content layout for a menu-bar metric slot. Replaces the old
/// `MenuBarMetricStyle` + `MenuBarDisplayMode` pickers with a single 5-option
/// content-shape picker (briefcase icon + value variants).
enum MenuBarTodayDisplay: String, CaseIterable, Sendable, Identifiable {
    case iconOnly
    case iconAndPrimary      // default: briefcase + raw primary metric
    case iconAndPercentage   // briefcase + "60%"
    case iconAndRemaining    // briefcase + "3h" / "$200"
    case valueOnly           // raw primary metric, no icon

    var id: String { rawValue }

    var label: String {
        switch self {
        case .iconOnly:          return L10n.t("Icon only")
        case .iconAndPrimary:    return L10n.t("Icon + primary metric")
        case .iconAndPercentage: return L10n.t("Icon + percentage")
        case .iconAndRemaining:  return L10n.t("Icon + remaining")
        case .valueOnly:         return L10n.t("Value only")
        }
    }

    var subtitle: String {
        switch self {
        case .iconOnly:          return L10n.t("Glyph only, no value")
        case .iconAndPrimary:    return L10n.t("Glyph + current value")
        case .iconAndPercentage: return L10n.t("Glyph + percent of goal")
        case .iconAndRemaining:  return L10n.t("Glyph + amount left to goal")
        case .valueOnly:         return L10n.t("Value only, no glyph")
        }
    }

    /// Whether this layout needs a configured goal target to be meaningful.
    var requiresGoal: Bool {
        self == .iconAndPercentage || self == .iconAndRemaining
    }
}

/// How a metric value is rendered next to its icon (week metric only).
enum MenuBarDisplayMode: String, CaseIterable, Sendable, Identifiable {
    case percentage   // "60%"
    case count        // "5h/8h" or "$200/$500"

    var id: String { rawValue }

    var label: String {
        switch self {
        case .percentage: return L10n.t("Percentage")
        case .count:      return L10n.t("Count vs goal")
        }
    }

    var subtitle: String {
        switch self {
        case .percentage: return L10n.t("Show as percentage (e.g., 60%)")
        case .count:      return L10n.t("Show count vs goal (e.g., 5h/8h)")
        }
    }
}

@MainActor
@Observable
final class AppStore {
    // MARK: - Auth state
    var isAuthenticated: Bool = false
    var lastError: String?

    // MARK: - Period + data
    var selectedPeriod: Period = .today
    var snapshot: EarningsSnapshot = .empty
    var todaySnapshot: EarningsSnapshot = .empty
    var previousSnapshot: EarningsSnapshot = .empty
    var sparkline: [DailyPoint] = []

    // MARK: - Loading
    private var loadingCount: Int = 0
    var isLoading: Bool { loadingCount > 0 }

    // MARK: - Settings (persisted via didSet -> UserDefaults)
    private static let kRefreshSeconds  = "UpworkBuddyRefreshSeconds"
    private static let kCurrencyCode    = "UpworkBuddyCurrency"
    private static let kHideSensitive   = "UpworkBuddyHideSensitive"
    private static let kMenuBarMetric   = "UpworkBuddyMenuBarMetric"
    private static let kDashboardMetric = "UpworkBuddyDashboardMetric"
    private static let kLaunchAtLogin   = "UpworkBuddyLaunchAtLogin"
    private static let kGoalHoursDaily  = "UpworkBuddyGoalHoursDaily"
    private static let kGoalHoursWeekly = "UpworkBuddyGoalHoursWeekly"
    private static let kGoalHoursMonthly = "UpworkBuddyGoalHoursMonthly"
    private static let kGoalHoursYearly  = "UpworkBuddyGoalHoursYearly"
    private static let kGoalEarningsDaily   = "UpworkBuddyGoalEarningsDaily"
    private static let kGoalEarningsWeekly  = "UpworkBuddyGoalEarningsWeekly"
    private static let kGoalEarningsMonthly = "UpworkBuddyGoalEarningsMonthly"
    private static let kGoalEarningsYearly  = "UpworkBuddyGoalEarningsYearly"
    private static let kGoalsEnabled        = "UpworkBuddyGoalsEnabled"
    private static let kMenuBarIconStyle = "UpworkBuddyMenuBarIconStyle"
    private static let kShortcuts        = "UpworkBuddyShortcuts"
    private static let kAppTheme         = "UpworkBuddyAppTheme"
    private static let kAppAppearance    = "UpworkBuddyAppAppearance"
    private static let kTodayMetricEnabled = "UpworkBuddyTodayMetricEnabled"
    private static let kTodayMetricStyle   = "UpworkBuddyTodayMetricStyle"
    private static let kWeekMetricEnabled  = "UpworkBuddyWeekMetricEnabled"
    private static let kWeekMetricStyle    = "UpworkBuddyWeekMetricStyle"
    private static let kWeekMetricMode     = "UpworkBuddyWeekMetricMode"
    private static let kTodayDisplayStyle  = "UpworkBuddyTodayDisplayStyle"
    private static let kWeekDisplayStyle   = "UpworkBuddyWeekDisplayStyle"
    private static let kProgressNotifEnabled = "UpworkBuddyProgressNotifEnabled"
    private static let kEnabledThresholds    = "UpworkBuddyEnabledThresholds"
    private static let kKnownThresholds      = "UpworkBuddyKnownThresholds"
    private static let kNotifySessionReset   = "UpworkBuddyNotifySessionReset"
    private static let kNotifySoundEnabled   = "UpworkBuddyNotifySoundEnabled"
    private static let kGoalCelebrationEnabled = "UpworkBuddyGoalCelebrationEnabled"
    private static let kCelebrationStyle       = "UpworkBuddyCelebrationStyle"
    private static let kCelebrationSound       = "UpworkBuddyCelebrationSound"
    private static let kCelebrationCustomSrc   = "UpworkBuddyCelebrationCustomSource"
    private static let kEyeBreakEnabled            = "UpworkBuddyEyeBreakEnabled"
    private static let kEyeBreakIntervalMinutes    = "UpworkBuddyEyeBreakIntervalMinutes"
    private static let kEyeBreakDurationSeconds    = "UpworkBuddyEyeBreakDurationSeconds"
    private static let kEyeBreakCustomText         = "UpworkBuddyEyeBreakCustomText"
    private static let kEyeBreakExternalOnly       = "UpworkBuddyEyeBreakExternalOnly"
    private static let kStandupEnabled             = "UpworkBuddyStandupEnabled"
    private static let kStandupIntervalMinutes     = "UpworkBuddyStandupIntervalMinutes"
    private static let kStandupDurationSeconds     = "UpworkBuddyStandupDurationSeconds"
    private static let kStandupCustomText          = "UpworkBuddyStandupCustomText"
    private static let kStandupExternalOnly        = "UpworkBuddyStandupExternalOnly"
    static let kPreferredLanguage = "UpworkBuddyPreferredLanguage"

    static let defaultThresholds: [Int] = [75, 90, 95]

    var refreshIntervalSeconds: Int {
        didSet { UserDefaults.standard.set(refreshIntervalSeconds, forKey: Self.kRefreshSeconds) }
    }

    var currency: String {
        didSet { UserDefaults.standard.set(currency, forKey: Self.kCurrencyCode) }
    }

    var hideSensitive: Bool {
        didSet { UserDefaults.standard.set(hideSensitive, forKey: Self.kHideSensitive) }
    }

    var menuBarMetric: MenuBarMetric {
        didSet { UserDefaults.standard.set(menuBarMetric.rawValue, forKey: Self.kMenuBarMetric) }
    }

    var dashboardMetric: MenuBarMetric {
        didSet { UserDefaults.standard.set(dashboardMetric.rawValue, forKey: Self.kDashboardMetric) }
    }

    var launchAtLogin: Bool {
        didSet {
            UserDefaults.standard.set(launchAtLogin, forKey: Self.kLaunchAtLogin)
            LoginItemManager.apply(enabled: launchAtLogin)
        }
    }

    var goalHoursDaily: Double {
        didSet { UserDefaults.standard.set(goalHoursDaily, forKey: Self.kGoalHoursDaily) }
    }

    var goalHoursWeekly: Double {
        didSet { UserDefaults.standard.set(goalHoursWeekly, forKey: Self.kGoalHoursWeekly) }
    }

    var goalHoursMonthly: Double {
        didSet { UserDefaults.standard.set(goalHoursMonthly, forKey: Self.kGoalHoursMonthly) }
    }

    var goalHoursYearly: Double {
        didSet { UserDefaults.standard.set(goalHoursYearly, forKey: Self.kGoalHoursYearly) }
    }

    var goalEarningsDaily: Double {
        didSet { UserDefaults.standard.set(goalEarningsDaily, forKey: Self.kGoalEarningsDaily) }
    }

    var goalEarningsWeekly: Double {
        didSet { UserDefaults.standard.set(goalEarningsWeekly, forKey: Self.kGoalEarningsWeekly) }
    }

    var goalEarningsMonthly: Double {
        didSet { UserDefaults.standard.set(goalEarningsMonthly, forKey: Self.kGoalEarningsMonthly) }
    }

    var goalEarningsYearly: Double {
        didSet { UserDefaults.standard.set(goalEarningsYearly, forKey: Self.kGoalEarningsYearly) }
    }

    var goalsEnabled: Bool {
        didSet {
            UserDefaults.standard.set(goalsEnabled, forKey: Self.kGoalsEnabled)
            if !goalsEnabled {
                GoalNotificationService.shared.cancelPending()
            }
        }
    }

    var menuBarIconStyle: MenuBarIconStyle {
        didSet { UserDefaults.standard.set(menuBarIconStyle.rawValue, forKey: Self.kMenuBarIconStyle) }
    }

    // MARK: - Per-period menu bar metrics

    var todayMetricEnabled: Bool {
        didSet { UserDefaults.standard.set(todayMetricEnabled, forKey: Self.kTodayMetricEnabled) }
    }

    var todayMetricStyle: MenuBarMetricStyle {
        didSet { UserDefaults.standard.set(todayMetricStyle.rawValue, forKey: Self.kTodayMetricStyle) }
    }

    var weekMetricEnabled: Bool {
        didSet { UserDefaults.standard.set(weekMetricEnabled, forKey: Self.kWeekMetricEnabled) }
    }

    var weekMetricStyle: MenuBarMetricStyle {
        didSet { UserDefaults.standard.set(weekMetricStyle.rawValue, forKey: Self.kWeekMetricStyle) }
    }

    var weekMetricMode: MenuBarDisplayMode {
        didSet { UserDefaults.standard.set(weekMetricMode.rawValue, forKey: Self.kWeekMetricMode) }
    }

    /// User-chosen content layout for the Today menu-bar slot.
    var todayDisplayStyle: MenuBarTodayDisplay {
        didSet { UserDefaults.standard.set(todayDisplayStyle.rawValue, forKey: Self.kTodayDisplayStyle) }
    }

    /// User-chosen content layout for the Week menu-bar slot.
    var weekDisplayStyle: MenuBarTodayDisplay {
        didSet { UserDefaults.standard.set(weekDisplayStyle.rawValue, forKey: Self.kWeekDisplayStyle) }
    }

    // MARK: - Progress notifications

    /// Master switch for progress notifications (threshold crossings + session resets).
    /// Goal-completion notifications still fire when goalsEnabled is on.
    var progressNotificationsEnabled: Bool {
        didSet { UserDefaults.standard.set(progressNotificationsEnabled, forKey: Self.kProgressNotifEnabled) }
    }

    /// Percentages (1…99) where the user wants a "you've hit X%" alert.
    var enabledThresholds: Set<Int> {
        didSet { persistIntSet(enabledThresholds, key: Self.kEnabledThresholds) }
    }

    /// Every threshold the user has ever added (defaults + custom). Drives the row list
    /// in settings so user-added rows persist with their toggle state.
    var knownThresholds: [Int] {
        didSet { persistIntArray(knownThresholds, key: Self.kKnownThresholds) }
    }

    var notifyOnSessionReset: Bool {
        didSet { UserDefaults.standard.set(notifyOnSessionReset, forKey: Self.kNotifySessionReset) }
    }

    var notificationSoundEnabled: Bool {
        didSet { UserDefaults.standard.set(notificationSoundEnabled, forKey: Self.kNotifySoundEnabled) }
    }

    /// Confetti / fireworks overlay when a goal is reached.
    var goalCelebrationEnabled: Bool {
        didSet { UserDefaults.standard.set(goalCelebrationEnabled, forKey: Self.kGoalCelebrationEnabled) }
    }

    /// Visual style for the celebration overlay.
    var celebrationStyle: CelebrationStyle {
        didSet { UserDefaults.standard.set(celebrationStyle.rawValue, forKey: Self.kCelebrationStyle) }
    }

    /// System sound played alongside the celebration overlay. `.off` mutes it.
    var celebrationSound: CelebrationSound {
        didSet { UserDefaults.standard.set(celebrationSound.rawValue, forKey: Self.kCelebrationSound) }
    }

    /// Persisted source for `CelebrationSound.custom`. Accepts:
    ///   • a `file://` URL pointing at a user-picked audio file, or
    ///   • a `http(s)://` URL the player will cache + replay.
    /// Empty string clears it.
    var celebrationCustomSource: String {
        didSet { UserDefaults.standard.set(celebrationCustomSource, forKey: Self.kCelebrationCustomSrc) }
    }

    // MARK: - Eye break

    /// Master switch for periodic eye-break sessions. When on, the
    /// `EyeBreakService` schedules a fullscreen break overlay every
    /// `eyeBreakIntervalMinutes`, pausing the Upwork refresh task for
    /// `eyeBreakDurationSeconds`.
    var eyeBreakEnabled: Bool {
        didSet { UserDefaults.standard.set(eyeBreakEnabled, forKey: Self.kEyeBreakEnabled) }
    }

    /// Minutes between breaks. Clamped to 1…180 by the settings UI.
    var eyeBreakIntervalMinutes: Int {
        didSet { UserDefaults.standard.set(eyeBreakIntervalMinutes, forKey: Self.kEyeBreakIntervalMinutes) }
    }

    /// Break duration in seconds. Clamped to 5…600 by the settings UI.
    var eyeBreakDurationSeconds: Int {
        didSet { UserDefaults.standard.set(eyeBreakDurationSeconds, forKey: Self.kEyeBreakDurationSeconds) }
    }

    /// User-customizable message shown on the lock overlay during a break.
    var eyeBreakCustomText: String {
        didSet { UserDefaults.standard.set(eyeBreakCustomText, forKey: Self.kEyeBreakCustomText) }
    }

    /// When true, only external (non-main) displays are covered by the
    /// lock overlay so the user can keep working/reading on the laptop screen.
    var eyeBreakExternalDisplaysOnly: Bool {
        didSet { UserDefaults.standard.set(eyeBreakExternalDisplaysOnly, forKey: Self.kEyeBreakExternalOnly) }
    }

    /// Runtime flag — true while a break overlay is on screen. Not persisted.
    var isEyeBreakActive: Bool = false

    /// Remaining seconds in the current break. Drives the on-screen countdown.
    var eyeBreakRemainingSeconds: Int = 0

    // MARK: - Standup

    /// Master switch for periodic standup / movement sessions. When on, the
    /// `StandupService` schedules a fullscreen break overlay every
    /// `standupIntervalMinutes`, pausing the Upwork refresh task for
    /// `standupDurationSeconds`.
    var standupEnabled: Bool {
        didSet { UserDefaults.standard.set(standupEnabled, forKey: Self.kStandupEnabled) }
    }

    /// Minutes between standup prompts. Clamped to 5…180 by the settings UI.
    var standupIntervalMinutes: Int {
        didSet { UserDefaults.standard.set(standupIntervalMinutes, forKey: Self.kStandupIntervalMinutes) }
    }

    /// Standup duration in seconds. Clamped to 30…600 by the settings UI.
    var standupDurationSeconds: Int {
        didSet { UserDefaults.standard.set(standupDurationSeconds, forKey: Self.kStandupDurationSeconds) }
    }

    /// User-customizable message shown on the lock overlay during a standup.
    var standupCustomText: String {
        didSet { UserDefaults.standard.set(standupCustomText, forKey: Self.kStandupCustomText) }
    }

    /// When true, only external (non-main) displays are covered by the
    /// lock overlay during a standup.
    var standupExternalDisplaysOnly: Bool {
        didSet { UserDefaults.standard.set(standupExternalDisplaysOnly, forKey: Self.kStandupExternalOnly) }
    }

    /// Runtime flag — true while a standup overlay is on screen. Not persisted.
    var isStandupActive: Bool = false

    /// Remaining seconds in the current standup. Drives the on-screen countdown.
    var standupRemainingSeconds: Int = 0

    /// Set by GoalNotificationService when a goal first crosses 100% in a bucket.
    /// Views observe this to play the confetti animation, then nil it out.
    var celebrationToken: UUID?

    /// Trigger a celebration: spawns the in-popover confetti (via observed
    /// token) AND a full-display overlay across every connected monitor.
    /// All entry points (auto goal-hit, manual settings trigger) should call
    /// this rather than writing `celebrationToken` directly so the overlay
    /// stays in sync.
    func celebrate() {
        let token = UUID()
        celebrationToken = token
        CelebrationOverlayController.shared.fire(
            token: token,
            style: celebrationStyle,
            sound: celebrationSound,
            customSource: celebrationCustomSource,
            palette: [
                Theme.accent,
                Theme.accentDeep,
                Theme.accentSoft,
                .yellow,
                .pink,
                .mint
            ]
        )
    }

    /// Tracks whether the menu bar popover is currently shown on screen.
    /// AppDelegate updates this via NSPopoverDelegate. Views gate visible-only
    /// effects (e.g. confetti) on this so animations don't burn through while
    /// the popover is hidden but the hosting view is still mounted.
    var popoverVisible: Bool = false

    /// Snapshot for the current week. Mirrors `snapshot` when `selectedPeriod == .week`,
    /// else fetched alongside today during refresh so the menu bar can show weekly progress
    /// independent of the dashboard's selected period.
    var weekSnapshot: EarningsSnapshot = .empty

    var appTheme: AppTheme {
        didSet { UserDefaults.standard.set(appTheme.rawValue, forKey: Self.kAppTheme) }
    }

    /// User-controlled light/dark/system override. The actual palette is
    /// resolved per-render by `ThemedRoot`.
    var appAppearance: AppAppearance {
        didSet { UserDefaults.standard.set(appAppearance.rawValue, forKey: Self.kAppAppearance) }
    }

    /// Per-action user-overridable shortcuts. `nil` value means "unbound".
    var shortcuts: [ShortcutAction: Shortcut?] {
        didSet { persistShortcuts() }
    }

    /// User-selected UI language. Changes are persisted immediately and applied
    /// to the Foundation locale machinery on next launch (matches the
    /// "restart the app" hint shown on the Language settings page).
    var preferredLanguage: AppLanguage {
        didSet {
            UserDefaults.standard.set(preferredLanguage.code, forKey: Self.kPreferredLanguage)
            UserDefaults.standard.set([preferredLanguage.code], forKey: "AppleLanguages")
            L10n.setLanguage(preferredLanguage.code)
        }
    }

    private let api = UpworkAPI()
    private var refreshTask: Task<Void, Never>?
    private var aceId: String?

    init() {
        let defaults = UserDefaults.standard
        let storedRefresh = defaults.integer(forKey: Self.kRefreshSeconds)
        self.refreshIntervalSeconds = storedRefresh > 0 ? storedRefresh : 300
        self.currency = defaults.string(forKey: Self.kCurrencyCode) ?? "USD"
        self.hideSensitive = defaults.bool(forKey: Self.kHideSensitive)
        let storedMetric = defaults.string(forKey: Self.kMenuBarMetric).flatMap(MenuBarMetric.init(rawValue:))
        self.menuBarMetric = storedMetric ?? .hours
        let storedDash = defaults.string(forKey: Self.kDashboardMetric).flatMap(MenuBarMetric.init(rawValue:))
        self.dashboardMetric = storedDash ?? .earnings

        // Reconcile launchAtLogin with actual SMAppService state — user may
        // have toggled it from System Settings → General → Login Items.
        let storedLaunch = defaults.bool(forKey: Self.kLaunchAtLogin)
        let actualLaunch = LoginItemManager.isEnabled
        self.launchAtLogin = actualLaunch || storedLaunch
        if storedLaunch != actualLaunch {
            UserDefaults.standard.set(actualLaunch, forKey: Self.kLaunchAtLogin)
        }

        let storedDaily = defaults.double(forKey: Self.kGoalHoursDaily)
        self.goalHoursDaily = storedDaily > 0 ? storedDaily : 0   // 0 hides ring
        let storedWeekly = defaults.double(forKey: Self.kGoalHoursWeekly)
        self.goalHoursWeekly = storedWeekly > 0 ? storedWeekly : 0
        self.goalHoursMonthly = defaults.double(forKey: Self.kGoalHoursMonthly)
        self.goalHoursYearly  = defaults.double(forKey: Self.kGoalHoursYearly)
        self.goalEarningsDaily   = defaults.double(forKey: Self.kGoalEarningsDaily)
        self.goalEarningsWeekly  = defaults.double(forKey: Self.kGoalEarningsWeekly)
        self.goalEarningsMonthly = defaults.double(forKey: Self.kGoalEarningsMonthly)
        self.goalEarningsYearly  = defaults.double(forKey: Self.kGoalEarningsYearly)
        // Default goals on for new installs.
        if defaults.object(forKey: Self.kGoalsEnabled) == nil {
            self.goalsEnabled = true
        } else {
            self.goalsEnabled = defaults.bool(forKey: Self.kGoalsEnabled)
        }

        let storedIcon = defaults.string(forKey: Self.kMenuBarIconStyle).flatMap(MenuBarIconStyle.init(rawValue:))
        self.menuBarIconStyle = storedIcon ?? .iconValue

        // Per-period metrics. Default: today on (percentage style), week off.
        if defaults.object(forKey: Self.kTodayMetricEnabled) == nil {
            self.todayMetricEnabled = true
        } else {
            self.todayMetricEnabled = defaults.bool(forKey: Self.kTodayMetricEnabled)
        }
        let storedTodayStyle = defaults.string(forKey: Self.kTodayMetricStyle)
            .flatMap(MenuBarMetricStyle.init(rawValue:))
        self.todayMetricStyle = storedTodayStyle ?? .percentage

        self.weekMetricEnabled = defaults.bool(forKey: Self.kWeekMetricEnabled)
        let storedWeekStyle = defaults.string(forKey: Self.kWeekMetricStyle)
            .flatMap(MenuBarMetricStyle.init(rawValue:))
        self.weekMetricStyle = storedWeekStyle ?? .percentage
        let storedWeekMode = defaults.string(forKey: Self.kWeekMetricMode)
            .flatMap(MenuBarDisplayMode.init(rawValue:))
        self.weekMetricMode = storedWeekMode ?? .percentage

        // Today/Week display style — migrate from legacy MenuBarMetricStyle when
        // user has no explicit value yet. `.percentage` → `.iconAndPercentage`,
        // all other legacy visualizations → `.iconAndPrimary`.
        let migratedToday: MenuBarTodayDisplay = (storedTodayStyle == .percentage)
            ? .iconAndPercentage : .iconAndPrimary
        let storedTodayDisplay = defaults.string(forKey: Self.kTodayDisplayStyle)
            .flatMap(MenuBarTodayDisplay.init(rawValue:))
        self.todayDisplayStyle = storedTodayDisplay ?? migratedToday

        let migratedWeek: MenuBarTodayDisplay = (storedWeekStyle == .percentage || storedWeekMode == .percentage)
            ? .iconAndPercentage : .iconAndPrimary
        let storedWeekDisplay = defaults.string(forKey: Self.kWeekDisplayStyle)
            .flatMap(MenuBarTodayDisplay.init(rawValue:))
        self.weekDisplayStyle = storedWeekDisplay ?? migratedWeek

        // Progress notifications. Default on, with [75,90,95] enabled, no reset alert, sound on, celebration on.
        if defaults.object(forKey: Self.kProgressNotifEnabled) == nil {
            self.progressNotificationsEnabled = true
        } else {
            self.progressNotificationsEnabled = defaults.bool(forKey: Self.kProgressNotifEnabled)
        }
        let storedKnown = (defaults.array(forKey: Self.kKnownThresholds) as? [Int]) ?? Self.defaultThresholds
        self.knownThresholds = storedKnown.isEmpty ? Self.defaultThresholds : storedKnown
        if let storedEnabled = defaults.array(forKey: Self.kEnabledThresholds) as? [Int] {
            self.enabledThresholds = Set(storedEnabled)
        } else {
            self.enabledThresholds = Set(Self.defaultThresholds)
        }
        self.notifyOnSessionReset = defaults.bool(forKey: Self.kNotifySessionReset)
        if defaults.object(forKey: Self.kNotifySoundEnabled) == nil {
            self.notificationSoundEnabled = true
        } else {
            self.notificationSoundEnabled = defaults.bool(forKey: Self.kNotifySoundEnabled)
        }
        if defaults.object(forKey: Self.kGoalCelebrationEnabled) == nil {
            self.goalCelebrationEnabled = true
        } else {
            self.goalCelebrationEnabled = defaults.bool(forKey: Self.kGoalCelebrationEnabled)
        }
        let storedStyle = defaults.string(forKey: Self.kCelebrationStyle).flatMap(CelebrationStyle.init(rawValue:))
        self.celebrationStyle = storedStyle ?? .fireworks
        let storedSound = defaults.string(forKey: Self.kCelebrationSound).flatMap(CelebrationSound.init(rawValue:))
        self.celebrationSound = storedSound ?? .off
        self.celebrationCustomSource = defaults.string(forKey: Self.kCelebrationCustomSrc) ?? ""

        // Eye break — default off, 20-20-20 rule values.
        self.eyeBreakEnabled = defaults.bool(forKey: Self.kEyeBreakEnabled)
        let storedInterval = defaults.integer(forKey: Self.kEyeBreakIntervalMinutes)
        self.eyeBreakIntervalMinutes = storedInterval > 0 ? storedInterval : 20
        let storedDuration = defaults.integer(forKey: Self.kEyeBreakDurationSeconds)
        self.eyeBreakDurationSeconds = storedDuration > 0 ? storedDuration : 20
        self.eyeBreakCustomText = defaults.string(forKey: Self.kEyeBreakCustomText)
            ?? L10n.t("Look 20 feet away for 20 seconds")
        self.eyeBreakExternalDisplaysOnly = defaults.bool(forKey: Self.kEyeBreakExternalOnly)

        // Standup — default off. 30 min interval / 120 sec duration follow
        // common ergonomic guidance (Stanford EHS microbreaks; active-microbreak
        // studies suggest 2–3 min of light movement every 30 min).
        self.standupEnabled = defaults.bool(forKey: Self.kStandupEnabled)
        let storedStandupInterval = defaults.integer(forKey: Self.kStandupIntervalMinutes)
        self.standupIntervalMinutes = storedStandupInterval > 0 ? storedStandupInterval : 30
        let storedStandupDuration = defaults.integer(forKey: Self.kStandupDurationSeconds)
        self.standupDurationSeconds = storedStandupDuration > 0 ? storedStandupDuration : 120
        self.standupCustomText = defaults.string(forKey: Self.kStandupCustomText)
            ?? L10n.t("Stand up, stretch, and move around")
        self.standupExternalDisplaysOnly = defaults.bool(forKey: Self.kStandupExternalOnly)

        let storedTheme = defaults.string(forKey: Self.kAppTheme).flatMap(AppTheme.init(rawValue:))
        self.appTheme = storedTheme ?? .codeBurn

        let storedAppearance = defaults.string(forKey: Self.kAppAppearance).flatMap(AppAppearance.init(rawValue:))
        self.appAppearance = storedAppearance ?? .system

        let storedLang = defaults.string(forKey: Self.kPreferredLanguage)
        let resolvedLang = AppLanguage.resolve(from: storedLang)
        self.preferredLanguage = resolvedLang
        L10n.setLanguage(resolvedLang.code)

        // Shortcuts: load JSON, fall back to per-action defaults.
        var loaded: [ShortcutAction: Shortcut?] = [:]
        if let data = defaults.data(forKey: Self.kShortcuts),
           let decoded = try? JSONDecoder().decode([String: ShortcutCodable].self, from: data) {
            for (rawKey, value) in decoded {
                guard let action = ShortcutAction(rawValue: rawKey) else { continue }
                loaded[action] = value.shortcut
            }
        }
        for action in ShortcutAction.allCases where loaded[action] == nil {
            loaded[action] = action.defaultShortcut
        }
        self.shortcuts = loaded
    }

    private func persistIntSet(_ set: Set<Int>, key: String) {
        UserDefaults.standard.set(Array(set).sorted(), forKey: key)
    }

    private func persistIntArray(_ arr: [Int], key: String) {
        UserDefaults.standard.set(arr, forKey: key)
    }

    /// Add a custom threshold (1…99) to the known list and enable it. No-op if already known.
    func addCustomThreshold(_ percent: Int) {
        let clamped = max(1, min(99, percent))
        if !knownThresholds.contains(clamped) {
            knownThresholds = (knownThresholds + [clamped]).sorted()
        }
        enabledThresholds.insert(clamped)
    }

    /// Remove a user-added custom threshold (only those outside the defaults).
    func removeCustomThreshold(_ percent: Int) {
        guard !Self.defaultThresholds.contains(percent) else { return }
        knownThresholds.removeAll { $0 == percent }
        enabledThresholds.remove(percent)
    }

    func setThreshold(_ percent: Int, enabled: Bool) {
        if enabled { enabledThresholds.insert(percent) }
        else { enabledThresholds.remove(percent) }
    }

    private func persistShortcuts() {
        var encodable: [String: ShortcutCodable] = [:]
        for (action, shortcut) in shortcuts {
            encodable[action.rawValue] = ShortcutCodable(shortcut: shortcut)
        }
        if let data = try? JSONEncoder().encode(encodable) {
            UserDefaults.standard.set(data, forKey: Self.kShortcuts)
        }
    }

    func setShortcut(_ shortcut: Shortcut?, for action: ShortcutAction) {
        shortcuts[action] = shortcut
    }

    func resetShortcut(for action: ShortcutAction) {
        shortcuts[action] = action.defaultShortcut
    }

    /// Re-read the system login-item state and update the toggle. Call from
    /// `applicationDidBecomeActive` so the UI reflects out-of-app changes.
    func reconcileLaunchAtLogin() {
        let actual = LoginItemManager.isEnabled
        if actual != launchAtLogin { launchAtLogin = actual }
    }

    /// Period-and-metric-aware goal lookup. Returns 0 when goals disabled or unset.
    func goalTarget(for metric: MenuBarMetric, period: Period) -> Double {
        guard goalsEnabled else { return 0 }
        switch (metric, period) {
        case (.hours, .today):  return goalHoursDaily
        case (.hours, .week):   return goalHoursWeekly
        case (.hours, .month):  return goalHoursMonthly
        case (.hours, .year):   return goalHoursYearly
        case (.earnings, .today): return goalEarningsDaily
        case (.earnings, .week):  return goalEarningsWeekly
        case (.earnings, .month): return goalEarningsMonthly
        case (.earnings, .year):  return goalEarningsYearly
        }
    }

    /// Convenience for the dashboard hero — uses currently-selected period and dashboard metric.
    var dashboardGoalTarget: Double {
        goalTarget(for: dashboardMetric, period: selectedPeriod)
    }

    /// Legacy hours-only accessor preserved for callers still keyed on hours.
    var goalHoursTarget: Double {
        goalTarget(for: .hours, period: selectedPeriod)
    }

    // MARK: - Bootstrap

    func bootstrap() async {
        if KeychainStore.read(.refresh) != nil {
            isAuthenticated = true
            await resolveAceAndRefresh(force: true)
        } else {
            isAuthenticated = false
        }
    }

    func resolveAceAndRefresh(force: Bool) async {
        do {
            aceId = try await api.fetchAccountingEntityId()
            await refresh(force: force)
        } catch {
            handle(error)
        }
    }

    // MARK: - Period

    func switchTo(period: Period) {
        guard period != selectedPeriod else { return }
        selectedPeriod = period
        Task { await refresh(force: false) }
    }

    // MARK: - Refresh

    func refresh(force: Bool) async {
        guard isAuthenticated else { return }
        guard let ace = aceId else {
            do {
                aceId = try await api.fetchAccountingEntityId()
            } catch {
                handle(error)
                return
            }
            await refresh(force: force)
            return
        }
        refreshTask?.cancel()
        let task = Task { @MainActor in
            await self.performRefresh(aceId: ace, force: force)
        }
        refreshTask = task
        await task.value
    }

    private func performRefresh(aceId: String, force: Bool) async {
        let periodRange = DateRanges.range(for: selectedPeriod)
        let prevRange = DateRanges.previousRange(for: selectedPeriod)
        let sparkRange = DateRanges.sparklineRange(days: selectedPeriod.sparklineDays)
        let todayRange = DateRanges.range(for: .today)
        let weekRange = DateRanges.range(for: .week)

        let key = ReportCache.Key(
            tenantId: "",
            rangeStart: periodRange.startString,
            rangeEnd: periodRange.endString
        )

        if !force, let cached = await ReportCache.shared.get(key) {
            snapshot = cached.snapshot
            sparkline = cached.daily.suffix(selectedPeriod.sparklineDays)
        }

        loadingCount += 1
        defer { loadingCount -= 1 }

        do {
            async let periodResult = api.fetchCombinedEarnings(range: periodRange, aceId: aceId)
            async let prevResult = api.fetchCombinedEarnings(range: prevRange, aceId: aceId)
            async let sparkResult = api.fetchCombinedEarnings(range: sparkRange, aceId: aceId)
            async let todayResult: (EarningsSnapshot, [DailyPoint])? = (selectedPeriod == .today)
                ? nil
                : api.fetchCombinedEarnings(range: todayRange, aceId: aceId)
            async let weekResult: (EarningsSnapshot, [DailyPoint])? = (selectedPeriod == .week)
                ? nil
                : api.fetchCombinedEarnings(range: weekRange, aceId: aceId)

            let (periodSnap, _) = try await periodResult
            let (prevSnap, _) = try await prevResult
            let (_, sparkDaily) = try await sparkResult
            let todayPair = try await todayResult
            let weekPair = try await weekResult

            snapshot = periodSnap
            previousSnapshot = prevSnap
            sparkline = sparkDaily
            await ReportCache.shared.set(key, snapshot: periodSnap, daily: sparkDaily)

            if selectedPeriod == .today {
                todaySnapshot = periodSnap
            } else if let pair = todayPair {
                todaySnapshot = pair.0
            }

            if selectedPeriod == .week {
                weekSnapshot = periodSnap
            } else if let pair = weekPair {
                weekSnapshot = pair.0
            }

            lastError = nil
            await GoalNotificationService.shared.evaluate(store: self)
        } catch is CancellationError {
            // Period changed mid-flight; ignore.
        } catch {
            handle(error)
        }
    }

    // MARK: - Auth

    func startLogin() {
        Task {
            do {
                try await OAuthClient.shared.startAuthorization()
            } catch {
                handle(error)
            }
        }
    }

    func completeLogin() async {
        isAuthenticated = true
        lastError = nil
        await resolveAceAndRefresh(force: true)
    }

    func logout() async {
        await OAuthClient.shared.logout()
        await ReportCache.shared.clear()
        aceId = nil
        snapshot = .empty
        todaySnapshot = .empty
        weekSnapshot = .empty
        previousSnapshot = .empty
        sparkline = []
        isAuthenticated = false
    }

    // MARK: - Errors

    private func handle(_ error: Error) {
        Log.app.error("AppStore error: \(error.localizedDescription, privacy: .public)")
        if case UpworkError.unauthorized = error {
            Task { await logout() }
        }
        lastError = error.localizedDescription
    }
}
