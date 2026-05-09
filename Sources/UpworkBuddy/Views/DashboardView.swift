import SwiftUI

struct DashboardView: View {
    @Environment(AppStore.self) private var store

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
                Divider().background(Theme.divider)
                footer
            }
        }
        .id(store.appTheme)
    }

    private var header: some View {
        HStack(spacing: 8) {
            HStack(spacing: 0) {
                Text("Upwork")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(Theme.textPrimary)
                Text("Buddy")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(Theme.accent)
            }
            Spacer()
            if store.isLoading {
                ProgressView().controlSize(.small)
            }
            iconButton(systemName: store.hideSensitive ? "eye.slash" : "eye",
                       help: store.hideSensitive ? "Show amounts" : "Hide amounts") {
                store.hideSensitive.toggle()
            }
            iconButton(systemName: "arrow.clockwise", help: "Refresh now") {
                Task { await store.refresh(force: true) }
            }
            iconButton(systemName: "gearshape", help: "Settings") {
                SettingsWindow.show(store: store)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
    }

    private func iconButton(systemName: String, help: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(Theme.textSecondary)
                .frame(width: 24, height: 24)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Theme.chipBg.opacity(0.5))
                )
        }
        .buttonStyle(.plain)
        .help(help)
    }

    private var footer: some View {
        HStack {
            if let err = store.lastError {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundStyle(Theme.accent)
                Text(err)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .font(.caption)
                    .foregroundStyle(Theme.textSecondary)
            } else {
                Text("Updated \(updatedRelative)")
                    .font(.caption)
                    .foregroundStyle(Theme.textTertiary)
            }
            Spacer()
            Button {
                NSApp.terminate(nil)
            } label: {
                Text("Quit")
                    .font(.system(size: 11, weight: .medium))
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
