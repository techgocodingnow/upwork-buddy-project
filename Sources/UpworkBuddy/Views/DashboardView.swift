import SwiftUI

struct DashboardView: View {
    @Environment(AppStore.self) private var store

    @State private var activeCelebration: UUID?

    var body: some View {
        ZStack {
            Theme.bgGradient.ignoresSafeArea()

            VStack(spacing: 0) {
                header
                Divider().background(Theme.divider)
                ScrollView {
                    VStack(spacing: 14) {
                        HeroSection(
                            snapshot: store.snapshot,
                            previous: store.previousSnapshot,
                            period: store.selectedPeriod,
                            currency: store.currency,
                            masked: store.hideSensitive,
                            primary: store.dashboardMetric,
                            goalTarget: store.dashboardGoalTarget
                        )
                        PeriodSegmentedControl(selection: store.selectedPeriod) { p in
                            store.switchTo(period: p)
                        }
                        if store.selectedPeriod == .today {
                            TodayPulse(
                                points: store.sparkline,
                                snapshot: store.snapshot,
                                currency: store.currency,
                                masked: store.hideSensitive
                            )
                        } else {
                            SparklineView(
                                points: store.sparkline,
                                currency: store.currency,
                                masked: store.hideSensitive,
                                metric: store.dashboardMetric
                            )
                            .zIndex(2)
                        }
                        ProjectsList(
                            projects: store.snapshot.projects,
                            currency: store.currency,
                            masked: store.hideSensitive
                        )
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                }
                MusicMiniPlayer()
                Divider().background(Theme.divider)
                footer
            }

            if let token = activeCelebration {
                ConfettiView(
                    palette: [
                        Theme.accent,
                        Theme.accentDeep,
                        Theme.accentSoft,
                        .yellow,
                        .pink,
                        .mint
                    ]
                ) {
                    if activeCelebration == token { activeCelebration = nil }
                }
                .transition(.opacity)
            }
        }
        .onChange(of: store.celebrationToken) { _, token in
            guard let token, store.goalCelebrationEnabled, store.popoverVisible else { return }
            activeCelebration = token
            store.celebrationToken = nil
        }
        .onChange(of: store.popoverVisible) { _, visible in
            guard visible,
                  let token = store.celebrationToken,
                  store.goalCelebrationEnabled
            else { return }
            activeCelebration = token
            store.celebrationToken = nil
        }
        .onAppear {
            if store.popoverVisible,
               let token = store.celebrationToken,
               store.goalCelebrationEnabled {
                activeCelebration = token
                store.celebrationToken = nil
            }
        }
    }

    private var header: some View {
        HStack(spacing: 8) {
            HStack(spacing: 0) {
                Text(loc: "Upwork")
                    .font(Theme.body(size: 15, weight: .semibold))
                    .foregroundStyle(Theme.textPrimary)
                Text(loc: "Buddy")
                    .font(Theme.body(size: 15, weight: .semibold))
                    .foregroundStyle(Theme.accentDeep)
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel(L10n.t("Upwork Buddy"))
            .accessibilityAddTraits(.isHeader)
            Spacer()
            if store.isLoading {
                ProgressView()
                    .controlSize(.small)
                    .accessibilityLabel(L10n.t("Loading"))
            }
            iconButton(systemName: store.hideSensitive ? "eye.slash" : "eye",
                       help: store.hideSensitive ? L10n.t("Show amounts") : L10n.t("Hide amounts")) {
                store.hideSensitive.toggle()
            }
            iconButton(systemName: "arrow.clockwise", help: L10n.t("Refresh now")) {
                Task { await store.refresh(force: true) }
            }
            iconButton(systemName: "gearshape", help: L10n.t("Settings")) {
                SettingsWindow.show(store: store)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
    }

    private func iconButton(systemName: String, help: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(Theme.body(size: 12, weight: .medium))
                .foregroundStyle(Theme.textSecondary)
                .frame(width: 24, height: 24)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Theme.chipBg.opacity(0.5))
                )
        }
        .buttonStyle(.plain)
        .help(help)
        .accessibilityLabel(help)
    }

    private var footer: some View {
        HStack {
            if let err = store.lastError {
                HStack(spacing: 4) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(Theme.accentDeep)
                        .accessibilityHidden(true)
                    Text(err)
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .font(.caption)
                        .foregroundStyle(Theme.textSecondary)
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel(L10n.t("Error: %@", err))
            } else {
                Text(L10n.t("Updated %@", updatedRelative))
                    .font(.caption)
                    .foregroundStyle(Theme.textTertiary)
                    .accessibilityLabel(L10n.t("Last updated %@", updatedRelative))
            }
            Spacer()
            Button {
                NSApp.terminate(nil)
            } label: {
                Text(loc: "Quit")
                    .font(Theme.body(size: 11, weight: .medium))
                    .foregroundStyle(Theme.textSecondary)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Theme.chipBg.opacity(0.5))
                    )
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
    }

    private var updatedRelative: String {
        let date = store.snapshot.generatedAt
        if date == .distantPast { return "—" }
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}
