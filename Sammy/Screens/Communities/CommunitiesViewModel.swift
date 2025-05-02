import Foundation
import Models
import Networking

@Observable
@MainActor
final class CommunitiesViewModel {
    @ObservationIgnored private let service: CommunityServiceProtocol

    private(set) var communities: [Community] = []
    private(set) var isLoading = false

    init(service: CommunityServiceProtocol = CommunityService()) {
        self.service = service
    }

    func loadCommunities() async {
        isLoading = true
        defer { isLoading = false }

        do {
            communities = try await service.fetchCommunities()
        } catch {
            print("Something went wrong! error: \(error.localizedDescription)")
        }
    }
}
