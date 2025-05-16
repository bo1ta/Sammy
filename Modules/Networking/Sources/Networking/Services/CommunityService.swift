import Factory
import Foundation
import Models

// MARK: - CommunityServiceProtocol

public protocol CommunityServiceProtocol {
    func fetchCommunities() async throws -> [Community]
}

// MARK: - CommunityService

public struct CommunityService: CommunityServiceProtocol {
    @Injected(\.client) private var client: APIClientProvider

    public func fetchCommunities() async throws -> [Community] {
        let request = APIRequest(method: .get, route: .community(.list))
        let data = try await client.dispatch(request)
        return try FetchCommunitiesResponse.createFrom(data).communities
    }
}

// MARK: CommunityService.FetchCommunitiesResponse

extension CommunityService {
    fileprivate struct FetchCommunitiesResponse: Decodable, DecodableModel {
        var communities: [Community]
    }
}
