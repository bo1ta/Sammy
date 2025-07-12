import SwiftUI

@main
struct SammyApp: App {
  @State private var appState = AppState()

  var body: some Scene {
    WindowGroup {
      Group {
        switch appState.currentState {
        case .loggedIn, .anonymous:
          AppTabView(isLoggedIn: appState.isLoggedIn)
        case .loggedOut:
          SplashView()
        case .loading:
          EmptyView()
            .springLoadingBehavior(.enabled)
        }
      }
      .toastView(toast: $appState.toast)
      .loadingView(isLoading: appState.isLoading)
      .task {
        await appState.initialLoad()
      }
      .onOpenURL { url in
        if appState.currentState == .loggedOut {
          appState.performAnonymousLogin()
        }
        AppNavigator.shared.handleDeepLink(url)
      }
    }
  }
}
