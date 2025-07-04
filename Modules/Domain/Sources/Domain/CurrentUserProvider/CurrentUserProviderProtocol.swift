import Foundation
import Models

public protocol CurrentUserProviderProtocol {
    func getCurrentState() -> CurrentUserState
    func setUser(_ localUser: LocalUser)
    func clearUser()
}

extension CurrentUserProviderProtocol {
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
