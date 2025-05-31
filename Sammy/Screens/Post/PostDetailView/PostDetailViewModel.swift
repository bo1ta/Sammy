import Factory
import Foundation
import Models
import OSLog
import SammyData

@Observable
@MainActor
final class PostDetailViewModel {

    // MARK: - Dependencies

    @ObservationIgnored
    @Injected(\.commentRepository) private var commentRepository: CommentRepositoryProtocol

    @ObservationIgnored
    @Injected(\.loadingManager) private var loadingManager: LoadingManager

    private let logger = Logger(subsystem: "com.Sammy", category: "PostDetailViewModel")

    // MARK: - Observed properties

    private(set) var isLoadingComments = false
    private(set) var comments: [Comment] = []
    private(set) var commentTree: [CommentNode] = []
    private(set) var errorMessage: String?
    private(set) var voteTask: Task<Void, Never>?

    // MARK: - Init

    let post: Post

    init(post: Post) {
        self.post = post
    }

    // MARK: - Public methods

    func fetchCommentsForPost() async {
        loadingManager.showLoading()
        defer { loadingManager.hideLoading() }

        do {
            comments = try await commentRepository.getCommentsForPostID(post.id)
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
                try await commentRepository.setVoteForComment(commentID, voteType: voteType)
            } catch {
                logger.error("Error voting comment. Error: \(error.localizedDescription)")
                errorMessage = "Error voting comment."
            }
        }
    }
}
