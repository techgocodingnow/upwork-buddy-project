import SwiftUI

struct DashboardView: View {
    @Environment(AppStore.self) private var store

    var body: some View {
        let skeleton = store.isShowingPeriodSkeleton
        let snapshot = skeleton ? placeholderSnapshot : store.snapshot
        let previous = skeleton ? .empty : store.previousSnapshot
        let sparkline = skeleton ? placeholderSparkline : store.sparkline
        ZStack {
            Theme.bgGradient.ignoresSafeArea()

            VStack(spacing: 0) {
                header
                separator
                ScrollView {
                    VStack(spacing: 12) {
                        HeroSection(
                            snapshot: snapshot,
                            previous: previous,
                            period: store.selectedPeriod,
                            currency: store.currency,
                            masked: store.hideSensitive,
                            primary: store.dashboardMetric,
                            goalTarget: store.dashboardGoalTarget
                        )
                        .redacted(reason: skeleton ? .placeholder : [])
                        PeriodSegmentedControl(selection: store.selectedPeriod) { p in
                            store.switchTo(period: p)
                        }
                        Group {
                            if store.selectedPeriod == .today {
                                TodayPulse(
                                    points: sparkline,
                                    snapshot: snapshot,
                                    currency: store.currency,
                                    masked: store.hideSensitive
                                )
                            } else {
                                SparklineView(
                                    points: sparkline,
                                    currency: store.currency,
                                    masked: store.hideSensitive,
                                    metric: store.dashboardMetric,
                                    title: chartTitle,
                                    period: store.selectedPeriod
                                )
                                .zIndex(2)
                            }
                        }
                        .frame(minHeight: 180, alignment: .top)
                        .redacted(reason: skeleton ? .placeholder : [])
                        ProjectsList(
                            projects: snapshot.projects,
                            currency: store.currency,
                            masked: store.hideSensitive
                        )
                        .frame(minHeight: 112, alignment: .top)
                        .redacted(reason: skeleton ? .placeholder : [])
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .transaction { $0.animation = nil }
                }
                MusicMiniPlayer()
                separator
                footer
            }
        }
    }

    private var placeholderSnapshot: EarningsSnapshot {
        EarningsSnapshot(
            totalHours: 42,
            totalEarnings: 2400,
            projects: [
                ProjectStat(contractId: "skeleton-1", title: "Loading project", hours: 18, earnings: 1100, hourlyRate: nil),
                ProjectStat(contractId: "skeleton-2", title: "Loading project", hours: 14, earnings: 800, hourlyRate: nil),
                ProjectStat(contractId: "skeleton-3", title: "Loading project", hours: 10, earnings: 500, hourlyRate: nil)
            ],
            generatedAt: Date()
        )
    }

    private var placeholderSparkline: [DailyPoint] {
        let count = store.selectedPeriod == .year ? 12 : store.selectedPeriod.sparklineDays
        let component: Calendar.Component = store.selectedPeriod == .year ? .month : .day
        return (0..<count).map { index in
            let date = Calendar.current.date(byAdding: component, value: index - count + 1, to: Date()) ?? Date()
            let value = Double((index % 5) + 2)
            return DailyPoint(date: date, earnings: value * 120, hours: value)
        }
    }

    private var chartTitle: String? {
        switch store.selectedPeriod {
        case .today:
            return nil
        case .week:
            return L10n.t("This week")
        case .month:
            return L10n.t("This month")
        case .year:
            return L10n.t("This year")
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

    private var separator: some View {
        Rectangle()
            .fill(Theme.divider.opacity(0.18))
            .frame(height: 0.5)
            .accessibilityHidden(true)
    }

    private func iconButton(systemName: String, help: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(Theme.body(size: 13, weight: .medium))
                .foregroundStyle(Theme.textSecondary)
                .frame(width: 28, height: 28)
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
        formatter.locale = L10n.currentLocale
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}
