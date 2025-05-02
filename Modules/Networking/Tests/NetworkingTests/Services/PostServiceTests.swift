import Foundation
import Testing
@testable import Networking

// MARK: - PostServiceTests

@Suite
class PostServiceTests: SammyTestBase {
    @Test
    func fetchPostsSuccess() async throws {
        let jsonData = try parseDataFromFile(name: "postsListResponse")
        let mockAPI = MockAPIProvider(expectedData: jsonData)

        let service = PostService(client: mockAPI)
        let posts = try await service.fetchPosts()
        #expect(posts.count == 2)
    }

    @Test
    func fetchPostsFailure() async throws {
        /// since we dont create any json data, the decoding will fail, and hence, throw an error
        let mockAPI = MockAPIProvider()

        let service = PostService(client: mockAPI)
        do {
            _ = try await service.fetchPosts()
            #expect(Bool(false)) // should never run
        } catch {
            #expect(error is DecodingError)
        }
    }
}

// MARK: PostServiceTests.MockAPIProvider

extension PostServiceTests {
    struct MockAPIProvider: APIProvider {
        var expectedData: Data?

        func dispatch(_: APIRequest) async throws -> Data {
            expectedData ?? Data()
        }
    }
}
