import Models

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

  func getCaptcha() async throws -> Captcha

  func verifyEmail(token: String) async throws

}

// MARK: - AuthService

public struct AuthService: AuthServiceProtocol {
  private let client: APIClientProvider
  private let tokenProvider: TokenProviderType

  public init(client: APIClientProvider = APIClient(), tokenProvider: TokenProviderType = TokenProvider.instance) {
    self.client = client
    self.tokenProvider = tokenProvider
  }

  public func register(
    username: String,
    password: String,
    showNSFW: Bool,
    email: String?,
    captchaUUID: String?,
    captchaResponse: String?,
    honeypot: String?,
    answer: String?)
    async throws -> AuthResponse
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

    return try AuthResponse.createFrom(data)
  }

  public func login(
    usernameOrEmail: String,
    password: String,
    twoFactoryAuthToken: String? = nil)
    async throws -> AuthResponse
  {
    var request = APIRequest(method: .post, route: .user(.login))
    request.body = [
      "username_or_email": usernameOrEmail,
      "password": password,
    ]
    if let twoFactoryAuthToken {
      request.body?["totp_2fa_token"] = twoFactoryAuthToken
    }

    let data = try await client.dispatch(request)

    let response = try AuthResponse.createFrom(data)
    if let jwtToken = response.jwt {
      try tokenProvider.storeToken(jwtToken)
    }
    return response
  }

  public func getCaptcha() async throws -> Captcha {
    let request = APIRequest(method: .get, route: .user(.getCaptcha))
    let data = try await client.dispatch(request)
    return try GetCaptchaResponse.createFrom(data).ok
  }

  public func verifyEmail(token: String) async throws {
    var request = APIRequest(method: .post, route: .user(.verifyEmail))
    request.body = ["token": token]
    _ = try await client.dispatch(request)
  }
}

// MARK: - AuthResponse

public struct AuthResponse: Decodable, DecodableModel, Sendable {
  let jwt: String?
  let registrationCreated: Bool
  let verifyEmailSent: Bool

  enum CodingKeys: String, CodingKey {
    case jwt
    case registrationCreated = "registration_created"
    case verifyEmailSent = "verify_email_sent"
  }
}

// MARK: - GetCaptchaResponse

private struct GetCaptchaResponse: DecodableModel {
  let ok: Captcha // swiftlint:disable:this identifier_name
}
