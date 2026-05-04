import SwiftUI

struct DashboardView: View {
    @Environment(AppStore.self) private var store
    @State private var showingSettings = false

    var body: some View {
        VStack(spacing: 0) {
            header
            ScrollView {
                VStack(spacing: 14) {
                    PeriodSegmentedControl(selection: store.selectedPeriod) { p in
                        store.switchTo(period: p)
                    }
                    HeroSection(
                        snapshot: store.snapshot,
                        period: store.selectedPeriod,
                        currency: store.currency
                    )
                    SparklineView(points: store.sparkline, currency: store.currency)
                        .padding(.horizontal, 4)
                    ProjectsList(projects: store.snapshot.projects, currency: store.currency)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
            }
            footer
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                Text("UpworkBuddy")
                    .font(.system(size: 13, weight: .semibold))
                if let tenant = store.tenants.first(where: { $0.id == store.selectedTenantId }) {
                    Text(tenant.title)
                        .font(.system(size: 10))
                        .foregroundStyle(.tertiary)
                        .lineLimit(1)
                }
            }
            Spacer()
            if store.isLoading {
                ProgressView().controlSize(.small)
            }
            Button {
                Task { await store.refresh(force: true) }
            } label: {
                Image(systemName: "arrow.clockwise")
            }
            .buttonStyle(.borderless)
            .help("Refresh now")
            Button { showingSettings = true } label: {
                Image(systemName: "gearshape")
            }
            .buttonStyle(.borderless)
            .help("Settings")
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(.bar)
    }

    private var footer: some View {
        HStack {
            if let err = store.lastError {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundStyle(.orange)
                Text(err)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            } else {
                Text("Updated \(updatedRelative)")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
            Spacer()
            Button {
                NSApp.terminate(nil)
            } label: {
                Text("Quit").font(.caption)
            }
            .buttonStyle(.borderless)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(.bar)
    }

    private var updatedRelative: String {
        let date = store.snapshot.generatedAt
        if date == .distantPast { return "—" }
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}
