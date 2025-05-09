import Foundation
import Models

protocol CurrentUserIDProvider {
    var currentUserID: PersonAttributes.ID? { get }
}

public class CurrentUserIDImpl: CurrentUserIDProvider {
    private static let userDefaultsKey = "currentUserID"

    var currentUserID: PersonAttributes.ID? {
        get {
            UserDefaults.standard.integer(forKey: Self.userDefaultsKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Self.userDefaultsKey)
        }
    }
}
