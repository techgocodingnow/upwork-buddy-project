import SwiftUI

struct SettingsView: View {
    @Environment(AppStore.self) private var store
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        @Bindable var store = store
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Settings").font(.headline)
                Spacer()
                Button("Done") { dismiss() }.keyboardShortcut(.defaultAction)
            }
            Divider()

            VStack(alignment: .leading, spacing: 6) {
                Text("Refresh interval")
                    .font(.subheadline.weight(.medium))
                Picker("", selection: refreshMinutesBinding(store: store)) {
                    Text("1 min").tag(1)
                    Text("5 min").tag(5)
                    Text("15 min").tag(15)
                    Text("30 min").tag(30)
                }
                .pickerStyle(.segmented)
                .labelsHidden()
            }

            VStack(alignment: .leading, spacing: 6) {
                Toggle(isOn: $store.hideSensitive) {
                    Text("Hide sensitive amounts")
                        .font(.subheadline.weight(.medium))
                }
                Text("Masks earnings, rates, and totals across the app and menu bar.")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("Currency")
                    .font(.subheadline.weight(.medium))
                Picker("", selection: $store.currency) {
                    Text("USD").tag("USD")
                }
                .pickerStyle(.menu)
                .labelsHidden()
                .disabled(true)
                Text("FX support coming in v2.")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }

            Spacer()
            Button(role: .destructive) {
                Task {
                    await store.logout()
                    dismiss()
                }
            } label: {
                Label("Disconnect Upwork", systemImage: "rectangle.portrait.and.arrow.right")
                    .frame(maxWidth: .infinity)
            }
            .controlSize(.large)
        }
        .padding(20)
        .frame(width: 360, height: 440)
    }

    /// Derived binding: stored as seconds in AppStore, surfaced as minutes in the picker.
    private func refreshMinutesBinding(store: AppStore) -> Binding<Int> {
        Binding(
            get: { max(1, store.refreshIntervalSeconds / 60) },
            set: { store.refreshIntervalSeconds = $0 * 60 }
        )
    }
}
