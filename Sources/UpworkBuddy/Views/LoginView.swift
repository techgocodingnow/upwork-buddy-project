import SwiftUI

struct LoginView: View {
    @Environment(AppStore.self) private var store

    var body: some View {
        ZStack {
            Theme.bgGradient.ignoresSafeArea()
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: "briefcase.fill")
                .font(.system(size: 56, weight: .light))
                .foregroundStyle(Theme.accent)
            VStack(spacing: 6) {
                HStack(spacing: 0) {
                    Text("Upwork").foregroundStyle(Theme.textPrimary)
                    Text("Buddy").foregroundStyle(Theme.accent)
                }
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
                    .font(.system(size: 13, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 9)
                    .foregroundStyle(.white)
                    .background(
                        RoundedRectangle(cornerRadius: 9).fill(Theme.accent)
                    )
            }
            .buttonStyle(.plain)
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
}
