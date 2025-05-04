import Foundation
import Models

// MARK: - CommentServiceProtocol

public protocol CommentServiceProtocol: Sendable {
    func getAllForPostID(_ id: Post.ID, queryOptions: CommentQueryOptions?) async throws -> [Comment]
    func setVoteForComment(_ commentID: Comment.ID, voteType: VoteType) async throws
}

// MARK: - CommentService

public struct CommentService: CommentServiceProtocol {
    private let client: APIProvider

    public init(client: APIProvider = APIClient()) {
        self.client = client
    }

    public func getAllForPostID(_ id: Post.ID, queryOptions: CommentQueryOptions?) async throws -> [Comment] {
        var queryParams = [
            URLQueryItem(name: "post_id", value: String(id)),
        ]
        if let queryOptions {
            let commentQueryItems = queryOptions.createQueryItems()
            queryParams.append(contentsOf: commentQueryItems)
        }

        let request = APIRequest(method: .get, route: .comment(.list), queryParams: queryParams)
        let data = try await client.dispatch(request)
        return try GetCommentsResponse.createFrom(data).comments
    }

    public func setVoteForComment(_ commentID: Comment.ID, voteType: VoteType) async throws {
        var request = APIRequest(method: .post, route: .comment(.like))
        request.body = [
            "comment_id": commentID,
            "score": voteType.rawValue,
        ]

        _ = try await client.dispatch(request)
    }
}

// MARK: CommentService.GetCommentsResponse

extension CommentService {
    private struct GetCommentsResponse: DecodableModel {
        let comments: [Comment]
    }
}
