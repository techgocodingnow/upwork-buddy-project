import SwiftUI

struct LoginView: View {
    @Environment(AppStore.self) private var store

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: "briefcase.fill")
                .font(.system(size: 56, weight: .light))
                .foregroundStyle(.tint)
            VStack(spacing: 6) {
                Text("UpworkBuddy")
                    .font(.title2.weight(.semibold))
                Text("Track your active Upwork projects, hours, and earnings — right from the menu bar.")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            Button {
                store.startLogin()
            } label: {
                Label("Connect Upwork", systemImage: "link")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .padding(.horizontal, 32)

            if let err = store.lastError {
                Text(err)
                    .font(.footnote)
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            Spacer()
            Text("A browser window will open for sign-in.")
                .font(.caption)
                .foregroundStyle(.tertiary)
                .padding(.bottom, 12)
        }
    }
}
