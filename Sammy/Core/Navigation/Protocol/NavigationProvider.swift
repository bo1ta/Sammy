import Foundation
import SwiftUI

// MARK: - NavigationProvider

@MainActor
protocol NavigationProvider: AnyObject {
  var paths: [AppTabs: [any NavigationDestination]] { get set }
  var currentTab: AppTabs { get set }
  var presentingSheet: ModalDestination? { get }
  var presentingFullScreenCover: ModalDestination? { get }

  func presentSheet(_ destination: ModalDestination)
  func dismissSheet()
  func presentFullScreenCover(_ destination: ModalDestination)
  func dismissFullScreenCover()
  func setNavigationPath(for destinations: [any NavigationDestination])
  func push<T: NavigationDestination>(_ destination: T)
  func pop()
  func popToRoot()
  func popOrDismiss()
  func handleDeepLink(_ url: URL)
}

extension NavigationProvider {
  func path<T: NavigationDestination>(for tab: AppTabs) -> [T] {
    paths[tab] as? [T] ?? []
  }

  func setPath(_ newPath: [some NavigationDestination], for tab: AppTabs) {
    paths[tab] = newPath
  }

  func pathBinding<T: NavigationDestination>(for tab: AppTabs, withDestinations _: T.Type) -> Binding<[T]> {
    Binding(
      get: { self.paths[tab] as? [T] ?? [] },
      set: { self.paths[tab] = $0 })
  }
}
