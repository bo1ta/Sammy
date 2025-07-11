import Domain
import Foundation
import Models
import OSLog

@Observable
@MainActor
final class PostDetailViewModel {

    // MARK: - Observed properties

    private(set) var isLoadingComments = false
    private(set) var comments: [Comment] = []
    private(set) var commentTree: [CommentNode] = []
    private(set) var errorMessage: String?
    private(set) var voteTask: Task<Void, Never>?

    // MARK: - Init

    let post: Post
    private let logger = Logger(subsystem: "com.Sammy", category: "PostDetailViewModel")
    private let commentProvider: CommentDataProviderProtocol

    init(post: Post, commentProvider: CommentDataProviderProtocol = CommentDataProvider()) {
        self.post = post
        self.commentProvider = commentProvider
    }

    // MARK: - Public methods

    func fetchCommentsForPost() async {
        SammyWrapper.showLoading()
        defer { SammyWrapper.hideLoading() }

        do {
            comments = try await commentProvider.getCommentsForPostID(post.id)
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
                try await commentProvider.setVoteForComment(commentID, voteType: voteType)
            } catch {
                logger.error("Error voting comment. Error: \(error.localizedDescription)")
                errorMessage = "Error voting comment."
            }
        }
    }
}
