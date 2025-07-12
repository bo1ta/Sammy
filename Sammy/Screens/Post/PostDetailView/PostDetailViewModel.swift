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
  private(set) var post: Post

  var isAuthenticated: Bool {
    CurrentUserProvider.instance.isAuthenticated
  }

  // MARK: - Init

  private let logger = Logger(subsystem: "com.Sammy", category: "PostDetailViewModel")
  private let commentProvider: CommentDataProviderProtocol
  private let postProvider: PostDataProviderProtocol
  private let appNavigator: NavigationProvider

  init(post: Post, commentProvider: CommentDataProviderProtocol = CommentDataProvider(), postProvider: PostDataProviderProtocol = PostDataProvider(), appNavigator: NavigationProvider = AppNavigator.shared) {
    self.post = post
    self.commentProvider = commentProvider
    self.postProvider = postProvider
    self.appNavigator = appNavigator
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

  func votePost(_ voteType: VoteType) {
    guard isAuthenticated else {
      appNavigator.presentSheet(.authentication)
      return
    }

    voteTask?.cancel()

    voteTask = Task {
      do {
        let updatedPost = try await postProvider.votePost(post.id, vote: voteType)
        self.post = updatedPost
      } catch {
        logger.error("Error voting post. Error: \(error)")
      }
    }
  }

  func voteComment(_ voteType: VoteType, commentID: Comment.ID) {
    guard isAuthenticated else {
      appNavigator.presentSheet(.authentication)
      return
    }

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
