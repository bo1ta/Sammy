import Factory
import Models
import Networking
import Storage

public typealias Comment = Models.Comment

// MARK: - CommentRepositoryProtocol

public protocol CommentRepositoryProtocol: Sendable {
    func getCommentsForPostID(_ postID: Int) async throws -> [Comment]
    func setVoteForComment(_ commentID: Comment.ID, voteType: VoteType) async throws
}

// MARK: - CommentRepository

public struct CommentRepository: CommentRepositoryProtocol {
    @Injected(\.commentService) private var service: CommentServiceProtocol
    private let dataStore = DataStore<Storage.Comment>()

    public func setVoteForComment(_ commentID: Comment.ID, voteType: VoteType) async throws {
        try await service.setVoteForComment(commentID, voteType: voteType)
    }

    public func getCommentsForPostID(_ postID: Int) async throws -> [Comment] {
        guard LastTimeUpdatedChecker.checkIfCommentsOldForPostID(postID) else {
            return await dataStore.getAll(matching: \.postAttributes.uniqueID == postID)
        }

        let comments = try await fetchAllComments(postID: postID)
        try await dataStore.importModels(comments)
        LastTimeUpdatedChecker.storeLastUpdateDateForCommentsOfPostID(postID)

        return comments
    }

    private func fetchAllComments(postID: Int, batchSize: Int = 50) async throws -> [Models.Comment] {
        var allComments: [Comment] = []
        var page = 1
        var hasMore = true

        while hasMore {
            let comments = try await service.getAllForPostID(
                postID,
                queryOptions: [.page(page), .limit(batchSize)])
            allComments.append(contentsOf: comments)
            hasMore = comments.count == batchSize
            page += 1
        }

        return allComments
    }
}
