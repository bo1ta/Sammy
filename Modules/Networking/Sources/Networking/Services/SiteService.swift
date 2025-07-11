import Models

// MARK: - SiteServiceProtocol

public protocol SiteServiceProtocol {
    func getSite() async throws -> SiteResponse
}

// MARK: - SiteService

public struct SiteService: SiteServiceProtocol {
    private let client: APIClientProvider

    public init(client: APIClientProvider = APIClient()) {
        self.client = client
    }

    public func getSite() async throws -> SiteResponse {
        let request = APIRequest(method: .get, route: .site(.index))
        let data = try await client.dispatch(request)
        return try SiteResponse.createFrom(data)
    }
}

// MARK: - SiteResponse + DecodableModel

extension SiteResponse: DecodableModel { }
