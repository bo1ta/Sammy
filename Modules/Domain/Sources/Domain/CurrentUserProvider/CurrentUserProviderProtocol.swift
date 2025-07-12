import Foundation
import Models

// MARK: - CurrentUserProviderProtocol

public protocol CurrentUserProviderProtocol {
  func getCurrentState() -> CurrentUserState
  func setUser(_ localUser: LocalUser)
  func clearUser()
}

extension CurrentUserProviderProtocol {
  public var currentUserID: Int? {
    switch getCurrentState() {
    case .authenticated(let localUser):
      localUser.id
    case .unauthenticated, .anonymous:
      nil
    }
  }
  
  public var currentPersonID: Int? {
    switch getCurrentState() {
    case .authenticated(let localUser):
      localUser.personID
    case .unauthenticated, .anonymous:
      nil
    }
  }
  
  public var isAuthenticated: Bool {
    guard currentUserID != nil else {
      return false
    }
    return true
  }
}
