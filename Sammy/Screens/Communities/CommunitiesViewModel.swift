import Foundation
import Models
import Networking
import OSLog

@Observable
@MainActor
final class CommunitiesViewModel {
    private let logger = Logger(subsystem: "com.Sammy", category: "CommunitiesViewModel")
    private let service: CommunityServiceProtocol

    private(set) var communities: [Community] = []
    private(set) var isLoading = false
    private(set) var errorMessage: String?

    init(service: CommunityServiceProtocol = CommunityService()) {
        self.service = service
    }

    func loadCommunities() async {
        isLoading = true
        defer { isLoading = false }

        do {
            communities = try await service.fetchCommunities()
        } catch {
            logger.error("Error loading communities. Error: \(error.localizedDescription)")
            errorMessage = "Something went wrong. Please try again later"
        }
    }
}
