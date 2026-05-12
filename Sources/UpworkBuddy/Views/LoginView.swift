import SwiftUI

struct LoginView: View {
    @Environment(AppStore.self) private var store

    var body: some View {
        ZStack {
            Theme.bgGradient.ignoresSafeArea()
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: "briefcase.fill")
                .font(Theme.body(size: 56, weight: .light))
                .foregroundStyle(Theme.accent)
                .accessibilityHidden(true)
            VStack(spacing: 6) {
                HStack(spacing: 0) {
                    Text(loc: "Upwork").foregroundStyle(Theme.textPrimary)
                    Text(loc: "Buddy").foregroundStyle(Theme.accentDeep)
                }
                .font(.title2.weight(.semibold))
                .accessibilityElement(children: .combine)
                .accessibilityLabel(L10n.t("UpworkBuddy"))
                .accessibilityAddTraits(.isHeader)
                Text(loc: "Track your active Upwork projects, hours, and earnings — right from the menu bar.")
                    .font(.callout)
                    .foregroundStyle(Theme.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            Button {
                store.startLogin()
            } label: {
                Label {
                    Text(loc: "Connect Upwork")
                } icon: {
                    Image(systemName: "link")
                }
                .font(Theme.body(size: 13, weight: .semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 9)
                .foregroundStyle(.white)
                .background(
                    RoundedRectangle(cornerRadius: 9).fill(Theme.accentDeep)
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
                    .accessibilityLabel(L10n.t("Error: %@", err))
            }
            Spacer()
            Text(loc: "A browser window will open for sign-in.")
                .font(.caption)
                .foregroundStyle(Theme.textTertiary)
                .padding(.bottom, 12)
        }
        }
    }
}
