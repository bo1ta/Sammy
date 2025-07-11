import Models
import Networking
import Storage

public typealias Comment = Models.Comment

// MARK: - CommentDataProviderProtocol

public protocol CommentDataProviderProtocol: Sendable {
    func getCommentsForPostID(_ postID: Int) async throws -> [Comment]
    func setVoteForComment(_ commentID: Comment.ID, voteType: VoteType) async throws
}

// MARK: - CommentDataProvider

public struct CommentDataProvider: CommentDataProviderProtocol, DataProvider {
    private var service: CommentServiceProtocol

    public init(service: CommentServiceProtocol = CommentService()) {
        self.service = service
    }

    public func setVoteForComment(_ commentID: Comment.ID, voteType: VoteType) async throws {
        try await service.setVoteForComment(commentID, voteType: voteType)
    }

    public func getCommentsForPostID(_ postID: Int) async throws -> [Comment] {
        guard LastTimeUpdatedChecker.isDataOld(forType: CommentEntity.self, withID: postID) else {
            return await readOnlyStore.commentsForPostID(postID)
        }

        let comments = try await fetchAllComments(postID: postID)
        try await writeOnlyStore.synchronize(comments, ofType: CommentEntity.self)
        LastTimeUpdatedChecker.storeLastUpdateDate(forType: CommentEntity.self, withID: postID)

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
