import SwiftUI

struct RootPostsView: View {
  @State private var navigator = AppNavigator.shared

  var body: some View {
    NavigationStack(path: navigator.pathBinding(for: .home, withDestinations: HomeDestinations.self)) {
      PostsView()
        .navigationDestination(for: HomeDestinations.self, destination: homeDestination(_:))
    }
  }

  @ViewBuilder
  private func homeDestination(_ destination: HomeDestinations) -> some View {
    switch destination {
    case .postDetail(let post):
      PostDetailView(post: post)
        .toolbarVisibility(.hidden, for: .tabBar)
    }
  }
}
