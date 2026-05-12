import SwiftUI

struct MenuBarContent: View {
    @Environment(AppStore.self) private var store

    var body: some View {
        ThemedRoot(store: store) {
            Group {
                if store.isAuthenticated {
                    DashboardView()
                } else {
                    LoginView()
                }
            }
            .frame(width: 380, height: 600)
            .task { await store.bootstrap() }
            .id(store.preferredLanguage)
        }
    }
}
