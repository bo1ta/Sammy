import Foundation
import Models
import Networking
import OSLog

// MARK: - PostsViewModel

@Observable
@MainActor
final class PostsViewModel {
    @ObservationIgnored private let service: PostServiceProtocol
    @ObservationIgnored private let logger = Logger(subsystem: "com.Sammy", category: "PostsViewModel")

    private(set) var posts: [Post] = []
    private(set) var isLoading = false

    var selectedDestination: Destination?

    init(service: PostServiceProtocol = PostService()) {
        self.service = service
    }

    func loadPosts() async {
        isLoading = true
        defer { isLoading = false }

        do {
            posts = try await service.fetchPosts()
        } catch {
            logger.error("\(error.localizedDescription)")
        }
    }
}

// MARK: PostsViewModel.Destination

extension PostsViewModel {
    enum Destination: Hashable {
        case detail(Post)
    }
}
