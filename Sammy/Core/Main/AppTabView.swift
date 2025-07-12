import SwiftUI

struct AppTabView: View {
  @State private var navigator = AppNavigator.shared
  var isLoggedIn: Bool

  var body: some View {
    TabView(selection: $navigator.currentTab) {
      Tab(AppTabs.home.title, systemImage: AppTabs.home.systemImageName, value: .home) {
        RootPostsView()
      }

      Tab(AppTabs.search.title, systemImage: AppTabs.search.systemImageName, value: .search) {
        RootSearchView()
      }

      Tab(AppTabs.communities.title, systemImage: AppTabs.communities.systemImageName, value: .communities) {
        RootCommunitiesView()
      }

      if isLoggedIn {
        Tab(AppTabs.profile.title, systemImage: AppTabs.profile.systemImageName, value: .profile) {
          NavigationStack(path: navigator.pathBinding(for: .profile, withDestinations: ProfileDestination.self)) {
            ProfileView()
          }
        }
      }
    }
    .sheet(item: $navigator.presentingSheet) { destination in
      modalViewBuilder(for: destination)
    }
    .fullScreenCover(item: $navigator.presentingFullScreenCover) { destination in
      modalViewBuilder(for: destination)
    }
  }

  @ViewBuilder
  private func modalViewBuilder(for destination: ModalDestination) -> some View {
    switch destination {
    case .authentication:
      SplashView(overrideDestination: .login)
    }
  }
}
