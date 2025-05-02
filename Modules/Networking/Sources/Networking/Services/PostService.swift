import Foundation
import Models

// MARK: - PostServiceProtocol

public protocol PostServiceProtocol: Sendable {
    func fetchPosts() async throws -> [Post]
    func getByID(_ id: Int) async throws -> Post
    func markAsRead(_ markedAsRead: Bool, id: Int) async throws
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

    public func getByID(_ id: Int) async throws -> Post {
        var request = APIRequest(method: .get, route: .post(.index))
        request.queryParams = [
            URLQueryItem(name: "id", value: String(id)),
        ]

        let data = try await client.dispatch(request)
        return try GetByIDResponse.createFrom(data).post
    }

    public func markAsRead(_ markedAsRead: Bool, id: Int) async throws {
        var request = APIRequest(method: .post, route: .post(.markAsRead))
        request.body = [
            "post_id": id,
            "read": markedAsRead,
        ]

        let data = try await client.dispatch(request)
        let response = try MarkAsReadResponse.createFrom(data)

        guard response.success else {
            throw PostServiceError.cannotMarkAsRead(postID: id)
        }
    }
}

// MARK: PostService.PostServiceError

extension PostService {
    enum PostServiceError: LocalizedError {
        case cannotMarkAsRead(postID: Int)

        var localizedDescription: String {
            switch self {
            case .cannotMarkAsRead(let postID):
                "Cannot mark as read post: \(postID)"
            }
        }
    }
}

// MARK: PostService.FetchPostsResponse

extension PostService {
    private struct FetchPostsResponse: Decodable, DecodableModel {
        var posts: [Post]
    }

    private struct GetByIDResponse: Decodable, DecodableModel {
        var post: Post

        enum CodingKeys: String, CodingKey {
            case post = "post_view"
        }
    }

    private struct MarkAsReadResponse: Decodable, DecodableModel {
        var success: Bool
    }
}
