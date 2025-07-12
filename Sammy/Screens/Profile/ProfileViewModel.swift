import Domain
import Models
import OSLog
import SwiftUI

@MainActor
@Observable
class ProfileViewModel {
  private let logger = Logger(subsystem: "com.Sammy", category: "ProfileViewModel")
  private let userDataProvider: UserDataProvider
  private let userStore: UserStore

  init(userRepository: UserDataProvider = UserDataProvider(), userStore: UserStore = UserStore.shared) {
    self.userDataProvider = userRepository
    self.userStore = userStore
  }

  // MARK: - Observed Properties

  private(set) var localUser: LocalUser?

  var selectedTab = ProfileTabs.posts
  var selectedAction = ProfileActions.profile

  // MARK: - Public methods

  func loadData() async {
    SammyWrapper.showLoading()
    defer { SammyWrapper.hideLoading() }

    do {
      localUser = try await userDataProvider.getLocalUser()
    } catch {
      logger.error("Error loading local user data. Error: \(error)")
      SammyWrapper.showError(MessageConstants.genericErrorMessage)
    }
  }

  func handleMenuItem(_ menuItem: ProfileMenuItems) {
    switch menuItem {
    case .myAccount:
      break
    case .saved:
      break
    case .history:
      break
    case .settings:
      break
    case .helpAndSupport:
      break
    case .logOut:
      userStore.logoutUser()
    }
  }
}
