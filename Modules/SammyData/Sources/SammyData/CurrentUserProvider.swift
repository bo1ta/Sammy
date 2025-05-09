import Models
import Foundation
import Networking

public protocol CurrentUserProvider {
    func getCurrentState() -> CurrentUserState
    func setUser(_ localUser: LocalUser)
    func clearUser()
}

extension CurrentUserProvider {
    var currentUserID: Int? {
        switch getCurrentState() {
        case .authenticated(let localUser):
            localUser.id
        case .unauthenticated:
            nil
        }
    }

    var currentPersonID: Int? {
        switch getCurrentState() {
        case .authenticated(let localUser):
            localUser.personID
        case .unauthenticated:
            nil
        }
    }
}

public class CurrentUserManager: CurrentUserProvider {
    private static let userDefaultsKey = "currentUser"

    private var cachedState: CurrentUserState?

    public func getCurrentState() -> CurrentUserState {
        if let cachedState {
            return cachedState
        }

        if let localUser = loadFromUserDefaults() {
            cachedState = .authenticated(localUser)
            return .authenticated(localUser)
        } else {
            return .unauthenticated
        }
    }

    public func setUser(_ localUser: LocalUser) {
        guard let data = try? JSONEncoder().encode(localUser) else {
            return
        }
        UserDefaults.standard.set(data, forKey: Self.userDefaultsKey)
        cachedState = .authenticated(localUser)
    }

    public func clearUser() {
        UserDefaults.standard.removeObject(forKey: Self.userDefaultsKey)
        cachedState = nil
    }

    private func loadFromUserDefaults() -> LocalUser? {
        guard
            let data = UserDefaults.standard.data(forKey: Self.userDefaultsKey),
            let localUser = try? LocalUser.createFrom(data)
        else {
            return nil
        }
        return localUser
    }


}

public enum CurrentUserState {
    case authenticated(LocalUser)
    case unauthenticated
}

extension LocalUser: DecodableModel { }
