import Combine
import Factory
import Foundation
import Models
import Networking
import Storage

// MARK: - UserStore

public final class UserStore: @unchecked Sendable {
    @Injected(\.userRepository) private var repository
    @Injected(\.authenticationHandler) private var authenticationHandler
    @Injected(\.currentUserProvider) private var currentUserProvider

    private(set) var currentPerson: Models.PersonAttributes?
    private(set) var isAnonymous = false

    var currentUserState: CurrentUserState {
        currentUserProvider.getCurrentState()
    }

    var currentUserID: Int? {
        currentUserProvider.currentUserID
    }

    var isLoggedIn: Bool {
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
        isAnonymous = true
        eventSubject.send(.didAnonymousLogin)
    }
}

// MARK: - UserStoreEvent

public enum UserStoreEvent {
    case didLogin
    case didAnonymousLogin
    case didLogout
}
