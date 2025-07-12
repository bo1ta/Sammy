import SwiftUI

struct RootSearchView: View {
  @State private var navigator = AppNavigator.shared

  var body: some View {
    NavigationStack(path: navigator.pathBinding(for: .search, withDestinations: SearchDestination.self)) {
      SearchView()
        .navigationDestination(for: SearchDestination.self, destination: searchDestination(_:))
    }
  }

  @ViewBuilder
  private func searchDestination(_ destination: SearchDestination) -> some View {
    EmptyView()
  }
}
