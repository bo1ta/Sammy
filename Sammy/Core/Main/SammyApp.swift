import SwiftUI

@main
struct SammyApp: App {
    @State private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            Group {
                switch appState.currentState {
                case .loggedIn, .anonymous:
                    AppTabView()
                case .loggedOut:
                    SplashView()
                case .loading:
                    EmptyView()
                        .springLoadingBehavior(.enabled)
                }
            }
            .toastView(toast: $appState.toast)
            .if(appState.isLoading) { view in
                view.overlay(LoadingOverlayView())
            }
            .task {
                await appState.initialLoad()
            }
        }
    }
}
