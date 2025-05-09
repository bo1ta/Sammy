import Foundation
import Factory
import Models
import Storage
import Networking
import Combine

public final class UserStore {
    @Injected(\.userRepository) private var repository
    @Injected(\.authenticationHandler) private var authenticationHandler
    @Injected(\.currentUserProvider) private var currentUserProvider

    private(set) var currentPerson: PersonAttributes?

    private let eventSubject = PassthroughSubject<UserStoreEvent, Never>()

    public var eventPublisher: AnyPublisher<UserStoreEvent, Never> {
        eventSubject
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    @discardableResult
    public func loadCurrentUser() async -> PersonAttributes? {
        do {
            currentPerson = try await repository.getCurrent()
            return currentPerson
        } catch {
            print("soemthing went wrong! Error: \(error)")
            return nil
        }
    }

    public func peformPostLogin() async {
        guard let _ = await loadCurrentUser() else {
            return
        }
        eventSubject.send(.didLogin)
    }
}

public enum UserStoreEvent {
    case didLogin
    case didLogout
}
