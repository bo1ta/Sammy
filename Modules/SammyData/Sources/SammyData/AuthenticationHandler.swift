import Factory
import Models
import Networking
import Storage

public protocol AuthenticationHandlerProtocol {
    func register(
        username: String,
        password: String,
        showNSFW: Bool,
        email: String?,
        captchaUUID: String?,
        captchaResponse: String?,
        honeypot: String?,
        answer: String?) async throws

    func login(usernameOrEmail: String, password: String, twoFactoryAuthToken: String?) async throws -> PersonAttributes
}

public struct AuthenticationHandler: AuthenticationHandlerProtocol {
    @Injected(\.currentUserProvider) private var currentUserProvider
    @Injected(\.userService) private var userService
    @Injected(\.authService) private var authService
    @Injected(\.siteService) private var siteService

    private let dataStore = DataStore<Person>()

    public func register(username: String, password: String, showNSFW: Bool, email: String?, captchaUUID: String?, captchaResponse: String?, honeypot: String?, answer: String?) async throws {
        try await authService.register(username: username, password: password, showNSFW: showNSFW, email: email, captchaUUID: captchaUUID, captchaResponse: captchaResponse, honeypot: honeypot, answer: answer)
    }

    public func login(usernameOrEmail: String, password: String, twoFactoryAuthToken: String?) async throws -> PersonAttributes {
        _ = try await authService.login(usernameOrEmail: usernameOrEmail, password: password, twoFactoryAuthToken: nil)

        /// login succeeded, time to fetch the current user
        let localUserView = try await siteService.getSite().myUser.localUserView

        /// store the local user in user defaults. containts important things like `person_id
        let localUser = localUserView.localUser
        currentUserProvider.setUser(localUser)

        /// save the person in the core data store
        let personAttributes = localUserView.person
        try await dataStore.importModel(personAttributes)

        return personAttributes
    }
}
