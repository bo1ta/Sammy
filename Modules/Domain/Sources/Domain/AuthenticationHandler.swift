import Factory
import Models
import Networking
import Storage

// MARK: - AuthenticationHandlerProtocol

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

    func login(usernameOrEmail: String, password: String, twoFactoryAuthToken: String?) async throws -> Models.PersonAttributes
}

// MARK: - AuthenticationHandler

public struct AuthenticationHandler: AuthenticationHandlerProtocol {
    @Injected(\.currentUserProvider) private var currentUserProvider
    @Injected(\.userService) private var userService
    @Injected(\.authService) private var authService
    @Injected(\.siteService) private var siteService

    private let dataStore = DataStore<Storage.PersonAttributes>()

    public func register(
        username: String,
        password: String,
        showNSFW: Bool,
        email: String?,
        captchaUUID: String?,
        captchaResponse: String?,
        honeypot: String?,
        answer: String?)
        async throws
    {
        try await authService.register(
            username: username,
            password: password,
            showNSFW: showNSFW,
            email: email,
            captchaUUID: captchaUUID,
            captchaResponse: captchaResponse,
            honeypot: honeypot,
            answer: answer)
    }

    public func login(
        usernameOrEmail: String,
        password: String,
        twoFactoryAuthToken _: String?)
        async throws -> Models.PersonAttributes
    {
        _ = try await authService.login(usernameOrEmail: usernameOrEmail, password: password, twoFactoryAuthToken: nil)

        /// login succeeded, time to fetch the current user
        let localUser = try await siteService.getSite().myUser.localUser

        /// store the local user in user defaults. containts important things like `person_id
        currentUserProvider.setUser(localUser)

        /// save the person in the core data store
        try await dataStore.importModel(localUser.personAttributes)

        return localUser.personAttributes
    }
}
