import Foundation
import Models
import Networking
import OSLog

// MARK: - PostsViewModel

@Observable
@MainActor
final class PostsViewModel {
    private let service: PostServiceProtocol

    init(service: PostServiceProtocol = PostService()) {
        self.service = service
    }

    private let logger = Logger(subsystem: "com.Sammy", category: "PostsViewModel")

    private(set) var posts: [Post] = []
    private(set) var isLoading = false
    private(set) var errorMessage: String?

    var selectedDestination: Destination?

    func loadPosts() async {
        isLoading = true
        defer { isLoading = false }

        do {
            posts = try await service.fetchPosts()
        } catch {
            logger.error("\(error.localizedDescription)")
            errorMessage = "An error occured. Please try again later."
        }
    }
}

// MARK: PostsViewModel.Destination

extension PostsViewModel {
    enum Destination: Hashable {
        case detail(Post)
    }
}
