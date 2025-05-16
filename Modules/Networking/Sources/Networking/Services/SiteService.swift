import Factory
import Models

// MARK: - SiteServiceProtocol

public protocol SiteServiceProtocol {
    func getSite() async throws -> SiteResponse
}

// MARK: - SiteService

public struct SiteService: SiteServiceProtocol {
    @Injected(\.client) private var client: APIClientProvider

    public func getSite() async throws -> SiteResponse {
        let request = APIRequest(method: .get, route: .site(.index))
        let data = try await client.dispatch(request)
        return try SiteResponse.createFrom(data)
    }
}

// MARK: - SiteResponse + DecodableModel

extension SiteResponse: DecodableModel { }
