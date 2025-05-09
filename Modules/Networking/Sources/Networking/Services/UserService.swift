import Factory
import Foundation
import Models

public protocol UserServiceProtocol: Sendable {
    func getPersonDetails(queryOptions: [PersonDetailsQueryOption]) async throws -> PersonDetails
    func getLoginTokens() async throws -> LoginTokensResponse?
}

// MARK: - UserService

public struct UserService: UserServiceProtocol {
    @Injected(\.client) private var client: APIClientProvider

    public func getPersonDetails(queryOptions: [PersonDetailsQueryOption]) async throws -> PersonDetails {
        guard !queryOptions.isEmpty else {
            throw UserServiceError.invalidQueryOptions
        }

        var request = APIRequest(method: .get, route: .user(.index))
        request.queryParams = queryOptions.map(\.queryItem)

        let data = try await client.dispatch(request)
        return try PersonDetails.createFrom(data)
    }

    public func getLoginTokens() async throws -> LoginTokensResponse? {
        let request = APIRequest(method: .get, route: .user(.listLogins))
        let data = try await client.dispatch(request)
        return try LoginTokensResponse.createArrayFrom(data).first
    }
}

extension UserService {
    enum UserServiceError: Error {
        case invalidQueryOptions
    }
}

extension PersonDetails: DecodableModel { }


public struct LoginTokensResponse: DecodableModel {
    public let userID: Int
    public let published: String
    public let ip: String?
    public let userAgent: String?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case published
        case ip
        case userAgent = "user_agent"
    }

    public init(userID: Int, published: String, ip: String?, userAgent: String?) {
        self.userID = userID
        self.published = published
        self.ip = ip
        self.userAgent = userAgent
    }
}
