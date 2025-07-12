import SwiftUI

// MARK: - NavigatorKey

private struct NavigatorKey: EnvironmentKey {
  static let defaultValue = AuthNavigator()
}

extension EnvironmentValues {
  var authNavigator: AuthNavigator {
    get { self[NavigatorKey.self] }
    set { self[NavigatorKey.self] = newValue }
  }
}

// MARK: - Navigator

@MainActor
protocol Navigator {
  associatedtype Destination

  func navigate(to destination: Destination)
  func pop()
  func popToRoot()
}
