import Factory

// MARK: - AuthServiceProtocol

public protocol AuthServiceProtocol: Sendable {
    func register(
        username: String,
        password: String,
        showNSFW: Bool,
        email: String?,
        captchaUUID: String?,
        captchaResponse: String?,
        honeypot: String?,
        answer: String?) async throws -> AuthResponse

    func login(usernameOrEmail: String, password: String, twoFactoryAuthToken: String?) async throws -> AuthResponse
}

// MARK: - AuthService

public struct AuthService: AuthServiceProtocol {
    @Injected(\.client) private var client: APIClientProvider
    @Injected(\.tokenProvider) private var tokenProvider: TokenProviderType

    public func register(
        username: String,
        password: String,
        showNSFW: Bool,
        email: String?,
        captchaUUID: String?,
        captchaResponse: String?,
        honeypot: String?,
        answer: String?)
        async throws -> AuthResponse {
            var request = APIRequest(method: .post, route: .user(.register))
            request.body = [
                "username": username,
                "password": password,
                "password_verify": password,
                "show_nsfw": showNSFW,
                "email": email as Any,
                "captcha_uuid": captchaUUID as Any,
                "captcha_answer": captchaResponse as Any,
                "honeypot": honeypot as Any,
                "answer": answer as Any,
            ]

            let data = try await client.dispatch(request)

            let response = try AuthResponse.createFrom(data)
            try tokenProvider.storeToken(response.jwt)
            return response
        }

    public func login(usernameOrEmail: String, password: String, twoFactoryAuthToken: String? = nil) async throws -> AuthResponse {
        var request = APIRequest(method: .post, route: .user(.login))
        request.body = [
            "username_or_email": usernameOrEmail,
            "password": password
        ]
        if let twoFactoryAuthToken {
            request.body?["totp_2fa_token"] = twoFactoryAuthToken
        }

        let data = try await client.dispatch(request)

        let response = try AuthResponse.createFrom(data)
        try tokenProvider.storeToken(response.jwt)
        return response
    }
}

// MARK: - AuthResponse

public struct AuthResponse: Decodable, DecodableModel {
    let jwt: String
    let registrationCreated: Bool
    let verifyEmailSent: Bool

    enum CodingKeys: String, CodingKey {
        case jwt
        case registrationCreated = "registration_created"
        case verifyEmailSent = "verify_email_sent"
    }
}
