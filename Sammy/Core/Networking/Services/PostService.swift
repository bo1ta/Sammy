import Foundation

// MARK: - PostServiceProtocol

protocol PostServiceProtocol: Sendable {
    func fetchPosts() async throws -> [Post]
}

// MARK: - PostService

struct PostService: PostServiceProtocol {
    private let client: APIProvider

    init(client: APIProvider = APIClient()) {
        self.client = client
    }

    func fetchPosts() async throws -> [Post] {
        let request = APIRequest(method: .get, route: .post(.list))
        let data = try await client.dispatch(request)
        return try FetchPostsResponse.createFrom(data).posts
    }
}

// MARK: PostService.FetchPostsReponse

extension PostService {
    fileprivate struct FetchPostsResponse: Decodable, DecodableModel {
        var posts: [Post]
    }
}
