import Testing
@testable import Models
@testable import Networking
@testable import Sammy

// MARK: - PostsViewModelTests

@Suite("PostsViewModel")
class PostsViewModelTests {
    func loadPostsIsSuccessful() async throws {
        let mockPost = PostFactory.create()
        let viewModel = await PostsViewModel(service: MockPostService(expectedPosts: [mockPost]))
        #expect(await viewModel.posts.isEmpty)

        await viewModel.loadPosts()
        #expect(await viewModel.posts.count == 1)
        #expect(await viewModel.posts.first == mockPost)
    }

    @Test
    func loadPostsFails() async throws {
        let viewModel = await PostsViewModel(service: MockPostService(shouldFail: true))
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
