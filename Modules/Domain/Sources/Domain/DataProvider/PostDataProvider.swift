import Models
import Networking
import os
import Storage

// MARK: - DataProvider

protocol DataProvider {
    var readOnlyStore: ReadOnlyStore { get }
    var writeOnlyStore: WriteOnlyStore { get }
}

extension DataProvider {
    var readOnlyStore: ReadOnlyStore {
        CoreDataStore.readOnlyStore()
    }

    var writeOnlyStore: WriteOnlyStore {
        CoreDataStore.writeOnlyStore()
    }
}

// MARK: - PostDataProviderProtocol

public protocol PostDataProviderProtocol: Sendable {
    func getByID(_ id: Post.ID) async throws -> Post
    func fetchPosts() async throws -> [Post]
}

// MARK: - PostDataProvider

public struct PostDataProvider: PostDataProviderProtocol, DataProvider, @unchecked Sendable {
    private let service: PostServiceProtocol

    init(service: PostServiceProtocol = PostService()) {
        self.service = service
    }

    private let logger = Logger()

    public func fetchPosts() async throws -> [Post] {
        do {
            if LastTimeUpdatedChecker.isDataOld(forType: PostEntity.self) {
                let posts = try await service.fetchPosts()
                try await writeOnlyStore.synchronize(posts, ofType: PostEntity.self)
                return posts
            } else {
                return await readOnlyStore.allPosts()
            }
        } catch let error as APIClientError {
            logger.error("Error fetching posts: \(error). Fallback to local datastore")

            let posts = await readOnlyStore.allPosts()

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
            if LastTimeUpdatedChecker.isDataOld(forType: PostEntity.self, withID: id) {
                let post = try await service.getByID(id)
                try await writeOnlyStore.synchronize(post, ofType: PostEntity.self)
                return post
            } else {
                let post = await readOnlyStore.postByID(id)
                guard let post else {
                    throw DomainError.unexpectedNil
                }
                return post
            }
        } catch let error as APIClientError {
            logger.error("Error fetching post: \(error). Fallback to local datastore")

            let post = await readOnlyStore.postByID(id)

            /// no reason to return an empty array.
            /// re-throw the api error in case we wanna show some alert
            guard let post else {
                throw error
            }

            return post
        }
    }
}

// MARK: - DomainError

public enum DomainError: Error {
    case unexpectedNil
}
