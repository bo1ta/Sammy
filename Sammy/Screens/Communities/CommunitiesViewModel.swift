import Factory
import Foundation
import Models
import Networking
import OSLog

@Observable
@MainActor
final class CommunitiesViewModel {
    @ObservationIgnored
    @Injected(\.communityService) private var service: CommunityServiceProtocol

    private let logger = Logger(subsystem: "com.Sammy", category: "CommunitiesViewModel")

    private(set) var communities: [Community] = []
    private(set) var isLoading = false
    private(set) var errorMessage: String?

    var searchText = ""

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
