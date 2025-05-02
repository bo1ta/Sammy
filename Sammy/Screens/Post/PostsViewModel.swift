import Foundation
import Models
import Networking
import OSLog

@Observable
@MainActor
final class PostsViewModel {
    @ObservationIgnored private let service: PostServiceProtocol
    @ObservationIgnored private let logger = Logger(subsystem: "com.Sammy", category: "PostsViewModel")

    private(set) var posts: [Post] = []
    private(set) var isLoading = false

    init(service: PostServiceProtocol = PostService()) {
        self.service = service
    }

    func loadPosts() async {
        isLoading = true
        defer { isLoading = false }

        do {
            posts = try await service.fetchPosts()

            if let firstPost = posts.first {
                let post = try await service.getByID(firstPost.postData.id)
                print("inca odata \(post)")
            }
        } catch {
            logger.error("\(error.localizedDescription)")
        }
    }
}
