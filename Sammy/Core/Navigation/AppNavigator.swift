import Foundation
import OSLog

// MARK: - AppNavigator

@Observable
@MainActor
final class AppNavigator: NavigationProvider {

  static let shared = AppNavigator()

  nonisolated init() { }

  // MARK: - Private properties

  private let logger = Logger()
  private var deepLinkTask: Task<Void, Never>?

  // MARK: - Presentation

  var presentingSheet: ModalDestination?
  var presentingFullScreenCover: ModalDestination?

  // MARK: - Tab Management

  var paths: [AppTabs: [any NavigationDestination]] = [:]

  var currentTab = AppTabs.home

  func switchToTab(_ targetTab: AppTabs) {
    guard currentTab != targetTab else {
      return
    }

    currentTab = targetTab
  }

  func setNavigationPath(for destinations: [any NavigationDestination]) {
    guard let first = destinations.first else {
      /// If an empty array is passed, clear the path for the *current* tab
      paths[currentTab] = []
      return
    }

    let targetTab = first.tab
    assert(destinations.allSatisfy { $0.tab == targetTab })

    switchToTab(targetTab)
    paths[targetTab] = destinations
  }

  func presentSheet(_ destination: ModalDestination) {
    self.presentingSheet = destination
  }

  func dismissSheet() {
    self.presentingSheet = nil
  }

  func presentFullScreenCover(_ destination: ModalDestination) {
    self.presentingFullScreenCover = destination
  }

  func dismissFullScreenCover() {
    self.presentingFullScreenCover = nil
  }

  func push(_ destination: some NavigationDestination) {
    switchToTab(destination.tab)
    appendDestination(destination)
  }

  private func appendDestination(_ destination: some NavigationDestination) {
    var currentPath = paths[destination.tab] ?? []
    currentPath.append(destination)
    paths[destination.tab] = currentPath
  }

  func pop() {
    var currentPath = paths[currentTab] ?? []
    if !currentPath.isEmpty {
      currentPath.removeLast()
      paths[currentTab] = currentPath
    }
  }

  func popToRoot() {
    paths[currentTab] = []
  }

  func popOrDismiss() {
    if presentingSheet != nil {
      dismissSheet()
    } else if presentingFullScreenCover != nil {
      dismissFullScreenCover()
    } else {
      pop()
    }
  }
}

// MARK: - DeepLink Handling

extension AppNavigator {
  func handleDeepLink(_ url: URL) {
    deepLinkTask?.cancel()

    deepLinkTask = Task {
      guard let navigationType = await DeepLinkHandler.navigationTypeForURL(url) else {
        logger.error("Cannot create navigation type for URL: \(url.absoluteString)")
        return
      }
      switch navigationType {
      case .none:
        logger.warning("No destination produced by deep link handler for \(url.absoluteString).")
      case .navigate(let path):
        self.setNavigationPath(for: path)
      case .presentCover(let modalDestination):
        self.presentFullScreenCover(modalDestination)
      }
    }
  }
}
