import Foundation
import Networking
import Models
import OSLog

@Observable
@MainActor
final class PostDetailViewModel: ObservableObject {
    @ObservationIgnored private(set) var voteTask: Task<Void, Never>?

    private(set) var comments: [Comment] = []
    private(set) var commentTree: [CommentNode] = []

    private let logger = Logger(subsystem: "com.Sammy", category: "PostDetailViewModel")
    private let commentService: CommentServiceProtocol

    let post: Post

    init(post: Post, commentService: CommentServiceProtocol = CommentService()) {
        self.post = post
        self.commentService = commentService
    }

    func fetchCommentsForPost() async {
        do {
            let queryOptions = CommentQueryOptions(limit: 50)
            comments = try await commentService.getAllForPostID(post.id, queryOptions: queryOptions)
            commentTree = CommentTreeBuilder.buildTree(from: comments)
        } catch {
            logger.error("Error loading cmments. Error: \(error.localizedDescription)")
        }
    }

    func handleVote(_ voteType: VoteType, commentID: Comment.ID) {
        voteTask?.cancel()

        voteTask = Task {
            do {
                try await commentService.setVoteForComment(commentID, voteType: voteType)
            } catch {
                logger.error("Error voting comment. Error: \(error.localizedDescription)")
            }
        }
    }
}
