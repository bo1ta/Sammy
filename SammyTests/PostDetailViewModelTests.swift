import Testing
@testable import Models
@testable import Networking
@testable import Sammy

// MARK: - PostDetailViewModelTests

@Suite("PostDetailViewModelTests")
struct PostDetailViewModelTests {
    @Test
    func fetchCommentsForPostSuccess() async throws {
        let mockComments = CommentBuilder().build()
        let mockPost = PostBuilder().build()

        let mockService = MockCommentService(expectedComments: [mockComments])

        let viewModel = await PostDetailViewModel(post: mockPost, commentService: mockService)
        #expect(await viewModel.comments.isEmpty)

        await viewModel.fetchCommentsForPost()
        #expect(await viewModel.comments.first == mockComments)
        #expect(await viewModel.errorMessage == nil)
    }

    @Test
    func fetchCommentsForPostFailure() async throws {
        let mockPost = PostBuilder().build()

        let mockService = MockCommentService(shouldFail: true)
        let viewModel = await PostDetailViewModel(post: mockPost, commentService: mockService)
        #expect(await viewModel.errorMessage == nil)

        await viewModel.fetchCommentsForPost()
        #expect(await viewModel.errorMessage == "Error loading comments.")
    }

    @Test
    func handleVoteSuccess() async throws {
        let mockPost = PostBuilder().build()

        let mockService = MockCommentService()
        let viewModel = await PostDetailViewModel(post: mockPost, commentService: mockService)

        await viewModel.handleVote(.upvote, commentID: 1)

        let task = try #require(await viewModel.voteTask)
        await task.value
        #expect(await viewModel.errorMessage == nil)
    }

    @Test
    func handleVoteFailure() async throws {
        let mockPost = PostBuilder().build()

        let mockService = MockCommentService(shouldFail: true)
        let viewModel = await PostDetailViewModel(post: mockPost, commentService: mockService)

        await viewModel.handleVote(.upvote, commentID: 1)

        let task = try #require(await viewModel.voteTask)
        await task.value
        #expect(await viewModel.errorMessage == "Error voting comment.")
    }
}

// MARK: PostDetailViewModelTests.MockCommentService

extension PostDetailViewModelTests {
    private struct MockCommentService: CommentServiceProtocol {
        var shouldFail = false
        var expectedComments: [Models.Comment] = []

        func setVoteForComment(_: Models.Comment.ID, voteType _: VoteType) async throws {
            if shouldFail {
                throw MockError.someError
            }
        }

        func getAllForPostID(_: Post.ID, queryOptions _: [CommentQueryOption]) async throws -> [Models.Comment] {
            if shouldFail {
                throw MockError.someError
            }
            return expectedComments
        }
    }
}
