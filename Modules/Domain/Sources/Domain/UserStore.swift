import Combine
import Foundation
import Models
import Networking
import Storage

// MARK: - UserStore

public final class UserStore: @unchecked Sendable {
  public static let shared = UserStore()

  private let repository: UserDataProviderProtocol
  private let authenticationHandler: AuthenticationHandlerProtocol
  private let currentUserProvider: CurrentUserProviderProtocol
  private let tokenProvider: TokenProviderType

  init(
    repository: UserDataProviderProtocol = UserDataProvider(),
    authenticationHandler: AuthenticationHandlerProtocol = AuthenticationHandler(),
    currentUserProvider: CurrentUserProviderProtocol = CurrentUserProvider(),
    tokenProvider: TokenProviderType = TokenProvider.instance)
  {
    self.repository = repository
    self.authenticationHandler = authenticationHandler
    self.currentUserProvider = currentUserProvider
    self.tokenProvider = tokenProvider
  }

  public private(set) var currentPerson: Models.PersonAttributes?
  public private(set) var isAnonymous = false

  public var currentUserState: CurrentUserState {
    currentUserProvider.getCurrentState()
  }

  public var currentUserID: Int? {
    currentUserProvider.currentUserID
  }

  public var isLoggedIn: Bool {
    if let currentPerson {
      return true
    }
    return false
  }

  private let eventSubject = PassthroughSubject<UserStoreEvent, Never>()

  public var eventPublisher: AnyPublisher<UserStoreEvent, Never> {
    eventSubject
      .receive(on: DispatchQueue.main)
      .eraseToAnyPublisher()
  }

  public func initialLoad() async {
    switch currentUserState {
    case .authenticated:
      await peformPostLogin()

    case .anonymous:
      performAnonymousLogin()

    case .unauthenticated:
      break
    }
  }

  @discardableResult
  public func loadCurrentUser() async -> Models.PersonAttributes? {
    do {
      currentPerson = try await repository.getCurrent()
      return currentPerson
    } catch {
      print("soemthing went wrong! Error: \(error)")
      return nil
    }
  }

  public func peformPostLogin() async {
    guard await loadCurrentUser() != nil else {
      return
    }
    eventSubject.send(.didLogin)
  }

  public func performAnonymousLogin() {
    /// clear token if one exists
    try? tokenProvider.clearToken()

    isAnonymous = true
    eventSubject.send(.didAnonymousLogin)
  }

  public func logoutUser() {
    currentUserProvider.clearUser()
    try? tokenProvider.clearToken()
    eventSubject.send(.didLogout)
  }
}

// MARK: - UserStoreEvent

public enum UserStoreEvent {
  case didLogin
  case didAnonymousLogin
  case didLogout
}
