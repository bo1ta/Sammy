import Factory

// MARK: - UserServiceProtocol

public protocol UserServiceProtocol: Sendable {
    func register(
        username: String,
        password: String,
        showNSFW: Bool,
        email: String?,
        captchaUUID: String?,
        captchaResponse: String?,
        honeypot: String?,
        answer: String?) async throws -> RegisterResponse

}

// MARK: - UserService

public struct UserService: UserServiceProtocol {
    @Injected(\.client) private var client: APIClientProvider

    public func register(
        username: String,
        password: String,
        showNSFW: Bool = false,
        email: String? = nil,
        captchaUUID: String? = nil,
        captchaResponse: String? = nil,
        honeypot: String? = nil,
        answer: String? = nil)
        async throws -> RegisterResponse
    {
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
        return try RegisterResponse.createFrom(data)
    }
}

// MARK: - RegisterResponse

public struct RegisterResponse: Decodable, DecodableModel {
    let jwt: String
    let registrationCreated: Bool
    let verifyEmailSent: Bool

    enum CodingKeys: String, CodingKey {
        case jwt
        case registrationCreated = "registration_created"
        case verifyEmailSent = "verify_email_sent"
    }
}
