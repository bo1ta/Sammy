import Factory
import Foundation
import Models
import Networking
import OSLog

@Observable
@MainActor
final class PostDetailViewModel {
    @ObservationIgnored
    @Injected(\.commentService) private var service: CommentServiceProtocol

    private(set) var comments: [Comment] = []
    private(set) var commentTree: [CommentNode] = []
    private(set) var errorMessage: String?
    private(set) var voteTask: Task<Void, Never>?

    private let logger = Logger(subsystem: "com.Sammy", category: "PostDetailViewModel")

    let post: Post

    init(post: Post) {
        self.post = post
    }

    func fetchAllComments(postId _: Int, batchSize: Int = 50) async throws -> [Comment] {
        var allComments: [Comment] = []
        var page = 1
        var hasMore = true

        while hasMore {
            let comments = try await service.getAllForPostID(post.id, queryOptions: [.page(page), .limit(batchSize)])

            allComments.append(contentsOf: comments)
            hasMore = comments.count == batchSize
            page += 1
        }

        return allComments
    }

    func fetchCommentsForPost() async {
        do {
            comments = try await fetchAllComments(postId: post.id)
            commentTree = CommentTreeBuilder.buildTree(from: comments)
        } catch {
            logger.error("Error loading cmments. Error: \(error.localizedDescription)")
            errorMessage = "Error loading comments."
        }
    }

    func handleVote(_ voteType: VoteType, commentID: Comment.ID) {
        voteTask?.cancel()

        voteTask = Task {
            do {
                try await service.setVoteForComment(commentID, voteType: voteType)
            } catch {
                logger.error("Error voting comment. Error: \(error.localizedDescription)")
                errorMessage = "Error voting comment."
            }
        }
    }
}
