import Foundation
import struct os.OSAllocatedUnfairLock

// MARK: - TokenProviderType

public protocol TokenProviderType: Sendable {
    func storeToken(_ token: String) throws
    func getAccessToken() throws -> String
    func clearToken() throws
    func isLoggedIn() -> Bool
}

// MARK: - TokenProvider

public final class TokenProvider: TokenProviderType {

    public static let instance = TokenProvider()

    // MARK: Private

    private static let tokenKey = "accessToken"

    private let keychain = KeychainManager(service: "TokenProvider")
    private let lockedToken = OSAllocatedUnfairLock<String?>(initialState: nil)

    private var cachedToken: String? {
        get {
            lockedToken.withLock { token in
                token
            }
        }
        set {
            lockedToken.withLock { token in
                token = newValue
            }
        }
    }

    // MARK: Public access

    public func isLoggedIn() -> Bool {
        do {
            try getAccessToken()
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }

    public func storeToken(_ token: String) throws {
        guard let data = token.data(using: .utf8) else {
            throw TokenError.invalidDataForToken
        }

        try keychain.set(data, forKey: Self.tokenKey)
        cachedToken = token
    }

    public func getAccessToken() throws -> String {
        if let cachedToken {
            return cachedToken
        }

        guard let data = try? keychain.get(byKey: Self.tokenKey) else {
            throw TokenError.tokenNotFound
        }

        guard let token = String(data: data, encoding: .utf8) else {
            throw TokenError.invalidDataForToken
        }

        cachedToken = token
        return token
    }

    public func clearToken() throws {
        do {
            try keychain.delete(byKey: Self.tokenKey)
            cachedToken = nil
        } catch {
            throw TokenError.cannotClearToken
        }
    }
}

// MARK: TokenProvider.TokenError

extension TokenProvider {
    enum TokenError: LocalizedError {
        case tokenNotFound
        case cannotClearToken
        case invalidDataForToken
    }
}
