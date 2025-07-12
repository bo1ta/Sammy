import Testing
@testable import Domain
@testable import Models
@testable import Networking
@testable import Sammy

// MARK: - PostDetailViewModelTests

class PostDetailViewModelTests {
  func fetchCommentsForPostSuccess() async throws {
    let mockComments = CommentFactory.createList(count: 2)
    let mockPost = PostFactory.create()
    let mockProvider = MockCommentProvider(expectedComments: mockComments)

    let viewModel = await PostDetailViewModel(post: mockPost, commentProvider: mockProvider)
    #expect(await viewModel.comments.isEmpty)

    await viewModel.fetchCommentsForPost()
    #expect(await viewModel.comments.first == mockComments.first)
    #expect(await viewModel.errorMessage == nil)
  }

  func fetchCommentsForPostFailure() async throws {
    let mockPost = PostFactory.create()
    let mockProvider = MockCommentProvider(shouldFail: true)

    let viewModel = await PostDetailViewModel(post: mockPost, commentProvider: mockProvider)
    #expect(await viewModel.errorMessage == nil)

    await viewModel.fetchCommentsForPost()
    #expect(await viewModel.errorMessage == "Error loading comments.")
  }

  @Test
  func handleVoteSuccess() async throws {
    let mockPost = PostFactory.create()
    let mockProvider = MockCommentProvider()

    let viewModel = await PostDetailViewModel(post: mockPost, commentProvider: mockProvider)
    await viewModel.handleVote(.upvote, commentID: 1)

    let task = try #require(await viewModel.voteTask)
    await task.value
    #expect(await viewModel.errorMessage == nil)
  }

  @Test
  func handleVoteFailure() async throws {
    let mockPost = PostFactory.create()
    let mockProvider = MockCommentProvider(shouldFail: true)

    let viewModel = await PostDetailViewModel(post: mockPost, commentProvider: mockProvider)
    await viewModel.handleVote(.upvote, commentID: 1)

    let task = try #require(await viewModel.voteTask)
    await task.value
    #expect(await viewModel.errorMessage == "Error voting comment.")
  }
}

// MARK: PostDetailViewModelTests.MockCommentProvider

extension PostDetailViewModelTests {
  private struct MockCommentProvider: CommentDataProviderProtocol {
    var shouldFail = false
    var expectedComments: [Models.Comment] = []

    func getCommentsForPostID(_: Int) async throws -> [Domain.Comment] {
      if shouldFail {
        throw MockError.someError
      }
      return expectedComments
    }

    func setVoteForComment(_: Models.Comment.ID, voteType _: VoteType) async throws {
      if shouldFail {
        throw MockError.someError
      }
    }
  }
}
