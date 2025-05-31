import FactoryTesting
import Testing
@testable import Factory
@testable import Models
@testable import Networking
@testable import Sammy

// MARK: - PostDetailViewModelTests

@Suite(.serialized)
struct PostDetailViewModelTests {
    func fetchCommentsForPostSuccess() async throws {
        let mockComments = CommentFactory.createList(count: 2)
        let mockPost = PostFactory.create()

        let mockService = MockCommentService(expectedComments: mockComments)
        Container.shared.commentService.register { mockService }

        let viewModel = await PostDetailViewModel(post: mockPost)
        #expect(await viewModel.comments.isEmpty)

        await viewModel.fetchCommentsForPost()
        #expect(await viewModel.comments.first == mockComments.first)
        #expect(await viewModel.errorMessage == nil)
    }

    func fetchCommentsForPostFailure() async throws {
        let mockPost = PostFactory.create()

        Container.shared.commentService.register {
            MockCommentService(shouldFail: true)
        }
        defer {
            Container.shared.commentService.reset()
        }

        let viewModel = await PostDetailViewModel(post: mockPost)
        #expect(await viewModel.errorMessage == nil)

        await viewModel.fetchCommentsForPost()
        #expect(await viewModel.errorMessage == "Error loading comments.")
    }

    @Test
    func handleVoteSuccess() async throws {
        let mockPost = PostFactory.create()

        Container.shared.commentService.register {
            MockCommentService()
        }
        defer {
            Container.shared.commentService.reset()
        }

        let viewModel = await PostDetailViewModel(post: mockPost)

        await viewModel.handleVote(.upvote, commentID: 1)

        let task = try #require(await viewModel.voteTask)
        await task.value
        #expect(await viewModel.errorMessage == nil)
    }

    @Test
    func handleVoteFailure() async throws {
        let mockPost = PostFactory.create()

        Container.shared.commentService.register {
            MockCommentService(shouldFail: true)
        }
        defer {
            Container.shared.commentService.reset()
        }

        let viewModel = await PostDetailViewModel(post: mockPost)
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
