import Foundation
import Models
import Networking

// MARK: - CurrentUserManagerProtocol

public protocol CurrentUserManagerProtocol {
    func getCurrentState() -> CurrentUserState
    func setUser(_ localUser: LocalUser)
    func clearUser()
}

extension CurrentUserManagerProtocol {
    var currentUserID: Int? {
        switch getCurrentState() {
        case .authenticated(let localUser):
            localUser.id
        case .unauthenticated, .anonymous:
            nil
        }
    }

    var currentPersonID: Int? {
        switch getCurrentState() {
        case .authenticated(let localUser):
            localUser.personID
        case .unauthenticated, .anonymous:
            nil
        }
    }
}

// MARK: - CurrentUserManager

public class CurrentUserManager: CurrentUserManagerProtocol {
    private static let currentUserKey = "currentUser"
    private static let anonymousUserKey = "anonymousUser"

    private var cachedState: CurrentUserState?

    public func getCurrentState() -> CurrentUserState {
        if let cachedState {
            return cachedState
        }

        let currentUserState = loadFromUserDefaults()
        cachedState = currentUserState
        return currentUserState
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

// MARK: - CurrentUserState

public enum CurrentUserState {
    case authenticated(LocalUser)
    case anonymous
    case unauthenticated
}

// MARK: - LocalUser + DecodableModel

extension LocalUser: DecodableModel { }
