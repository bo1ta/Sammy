import Foundation
import Testing
@testable import Networking

// MARK: - CommunityServiceTests

@Suite
class CommunityServiceTests: SammyTestBase {
    @Test
    func fetchCommunitiesSuccess() async throws {
        let jsonData = try parseDataFromFile(name: "communityListResponse")
        let mockAPI = MockAPIProvider(expectedData: jsonData)

        let service = CommunityService(client: mockAPI)
        let communities = try await service.fetchCommunities()
        #expect(communities.count == 2)
    }

    @Test
    func fetchCommunitiesFailure() async throws {
        /// since we dont create any json data, the decoding will fail, and hence, throw an error
        let mockAPI = MockAPIProvider()

        let service = CommunityService(client: mockAPI)
        do {
            _ = try await service.fetchCommunities()
            #expect(Bool(false)) // should never run
        } catch {
            #expect(error is DecodingError)
        }
    }
}
