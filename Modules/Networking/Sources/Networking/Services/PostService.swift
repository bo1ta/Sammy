import Foundation
import Models

// MARK: - PostServiceProtocol

public protocol PostServiceProtocol: Sendable {
    func fetchPosts() async throws -> [Post]
}

// MARK: - PostService

public struct PostService: PostServiceProtocol {
    private let client: APIProvider

    public init(client: APIProvider = APIClient()) {
        self.client = client
    }

    public func fetchPosts() async throws -> [Post] {
        let request = APIRequest(method: .get, route: .post(.list))
        let data = try await client.dispatch(request)
        return try FetchPostsResponse.createFrom(data).posts
    }
}

// MARK: PostService.FetchPostsResponse

extension PostService {
    fileprivate struct FetchPostsResponse: Decodable, DecodableModel {
        var posts: [Post]
    }
}
