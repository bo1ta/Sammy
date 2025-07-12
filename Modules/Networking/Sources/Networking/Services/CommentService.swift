import Foundation
import Models

// MARK: - CommentServiceProtocol

public protocol CommentServiceProtocol: Sendable {
  func getAllForPostID(_ id: Post.ID, queryOptions: [CommentQueryOption]) async throws -> [Comment]
  func setVoteForComment(_ commentID: Comment.ID, voteType: VoteType) async throws
}

// MARK: - CommentService

public struct CommentService: CommentServiceProtocol {
  private let client: APIClientProvider

  public init(client: APIClientProvider = APIClient()) {
    self.client = client
  }

  public func getAllForPostID(_ id: Post.ID, queryOptions: [CommentQueryOption] = []) async throws -> [Comment] {
    var queryParams = [
      URLQueryItem(name: "post_id", value: String(id)),
    ]
    queryParams.append(contentsOf: queryOptions.compactMap(\.queryItem))

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
