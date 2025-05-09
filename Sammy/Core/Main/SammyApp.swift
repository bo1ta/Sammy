import SwiftUI

@main
struct SammyApp: App {
    @State private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            Group {
                switch appState.currentState {
                case .loggedIn:
                    AppTabView()
                case .loggedOut:
                    LoginView()
                case .loading:
                    EmptyView()
                        .springLoadingBehavior(.enabled)
                }
            }
            .toastView(toast: $appState.toast)
            .task {
              await appState.initialLoad()
            }
        }
    }
}
