import Models
import Networking
import Storage
import Factory
import os

public protocol PostDataProviderProtocol: Sendable {
    func getByID(_ id: Post.ID) async throws -> Post
    func fetchPosts() async throws -> [Post]
}

public typealias Post = Models.Post

public struct PostDataProvider: PostDataProviderProtocol, @unchecked Sendable {
    @Injected(\.postService) private var service: PostServiceProtocol

    private let dataStore = DataStore<Storage.Post>()
    private let logger = Logger()

    public func fetchPosts() async throws -> [Post] {
        do {
            if LastTimeUpdatedChecker.isDataOld(forType: Storage.Post.self) {
                let posts = try await service.fetchPosts()
                try await dataStore.importModels(posts)
                return posts
            } else {
                return await dataStore.getAll()
            }
        } catch let error as APIClientError {
            logger.error("Error fetching posts: \(error). Fallback to local datastore")

            let posts = await dataStore.getAll()

            /// no reason to return an empty array.
            /// re-throw the api error in case we wanna show some alert
            guard !posts.isEmpty else {
                throw error
            }

            return posts
        }
    }

    public func getByID(_ id: Post.ID) async throws -> Post {
        do {
            if LastTimeUpdatedChecker.isDataOld(forType: Storage.Post.self, withID: id) {
                let post = try await service.getByID(id)
                try await dataStore.importModel(post)
                return post
            } else {
                let post = await dataStore.first(where: \.postID == id)
                guard let post else {
                    throw DomainError.unexpectedNil
                }
                return post
            }
        } catch let error as APIClientError {
            logger.error("Error fetching post: \(error). Fallback to local datastore")

            let post = await dataStore.first(where: \.postID == id)

            /// no reason to return an empty array.
            /// re-throw the api error in case we wanna show some alert
            guard let post else {
                throw error
            }

            return post
        }
    }
}

public enum DomainError: Error {
    case unexpectedNil
}
