import FactoryTesting
import Testing
@testable import Factory
@testable import Models
@testable import Networking
@testable import Sammy

// MARK: - PostsViewModelTests

@Suite("PostsViewModel")
struct PostsViewModelTests {
    func loadPostsIsSuccessful() async throws {
        let mockPost = PostFactory.create()
        Container.shared.postService.register {
            MockPostService(expectedPosts: [mockPost])
        }
        defer {
            Container.shared.postService.reset()
        }

        let viewModel = await PostsViewModel()
        #expect(await viewModel.posts.isEmpty)

        await viewModel.loadPosts()
        #expect(await viewModel.posts.count == 1)
        #expect(await viewModel.posts.first == mockPost)
    }

    @Test
    func loadPostsFails() async throws {
        Container.shared.postService.register {
            MockPostService(shouldFail: true)
        }
        defer {
            Container.shared.postService.reset()
        }

        let viewModel = await PostsViewModel()
        #expect(await viewModel.posts.isEmpty)

        await viewModel.loadPosts()
        #expect(await viewModel.posts.isEmpty)
        #expect(await viewModel.errorMessage == "An error occured. Please try again later.")
    }
}

// MARK: PostsViewModelTests.MockPostService

extension PostsViewModelTests {
    private struct MockPostService: PostServiceProtocol {
        var expectedPosts: [Post] = []
        var shouldFail = false

        func fetchPosts() async throws -> [Post] {
            if shouldFail {
                throw MockError.someError
            }
            return expectedPosts
        }

        func getByID(_: Post.ID) async throws -> Post {
            guard !shouldFail else {
                throw MockError.someError
            }

            if let post = expectedPosts.first {
                return post
            }
            throw MockError.someError
        }

        func markAsRead(_: Bool, id _: Int) async throws {
            if shouldFail {
                throw MockError.someError
            }
        }
    }
}
