import SwiftUI

struct RootCommunitiesView: View {
  @State private var navigator = AppNavigator.shared

  var body: some View {
    NavigationStack(path: navigator.pathBinding(for: .communities, withDestinations: CommunitiesDestination.self)) {
      CommunitiesView()
        .navigationDestination(for: CommunitiesDestination.self, destination: destinationView(_:))
    }
  }

  @ViewBuilder
  private func destinationView(_ destination: CommunitiesDestination) -> some View {
    EmptyView()
  }
}
