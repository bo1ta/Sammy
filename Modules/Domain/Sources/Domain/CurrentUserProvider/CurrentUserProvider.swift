import Foundation
import Models
import protocol Networking.DecodableModel

// MARK: - CurrentUserProvider

public class CurrentUserProvider: CurrentUserProviderProtocol {
  private static let currentUserKey = "currentUser"
  private static let anonymousUserKey = "anonymousUser"

  public nonisolated(unsafe) static let instance: CurrentUserProviderProtocol = CurrentUserProvider()

  private var cachedState: CurrentUserState?

  public func getCurrentState() -> CurrentUserState {
    if let cachedState {
      return cachedState
    }

    let currentUserState = loadFromUserDefaults()
    cachedState = currentUserState
    return currentUserState
  }

  public var currentLocalUser: LocalUser? {
    switch getCurrentState() {
    case .authenticated(let user):
      return user
    default:
      return nil
    }
  }

  public func setUser(_ localUser: LocalUser) {
    guard let data = try? JSONEncoder().encode(localUser) else {
      return
    }
    UserDefaults.standard.set(data, forKey: Self.currentUserKey)
    cachedState = .authenticated(localUser)
  }

  public func setIsAnonymousUser(_ isAnonymous: Bool) {
    UserDefaults.standard.set(isAnonymous, forKey: Self.anonymousUserKey)
  }

  public func clearUser() {
    UserDefaults.standard.removeObject(forKey: Self.currentUserKey)
    cachedState = nil
  }

  private func loadFromUserDefaults() -> CurrentUserState {
    if let localUser = loadCurrentUser() {
      .authenticated(localUser)
    } else if loadIsAnonymousUser() == true {
      .anonymous
    } else {
      .unauthenticated
    }
  }

  private func loadIsAnonymousUser() -> Bool {
    UserDefaults.standard.bool(forKey: Self.anonymousUserKey)
  }

  private func loadCurrentUser() -> LocalUser? {
    guard
      let data = UserDefaults.standard.data(forKey: Self.currentUserKey),
      let localUser = try? LocalUser.createFrom(data)
    else {
      return nil
    }
    return localUser
  }
}

// MARK: - LocalUser + DecodableModel

extension LocalUser: DecodableModel { }
