import FactoryTesting
import Testing
@testable import Factory
@testable import Models
@testable import Networking
@testable import Sammy

// MARK: - CommunityViewModelTests

@Suite("CommunityViewModelTests")
struct CommunityViewModelTests {
    @Test(.container)
    func loadCommunitiesSuccess() async throws {
        let mockCommunity = CommunityBuilder().build()
        let mockService = MockCommunityService(expectedCommunities: [mockCommunity])
        Container.shared.communityService.register { mockService }

        let viewModel = await CommunitiesViewModel()
        #expect(await viewModel.communities.isEmpty)

        await viewModel.loadCommunities()
        #expect(await viewModel.communities.first == mockCommunity)
        #expect(await viewModel.errorMessage == nil)
    }

    @Test(.container)
    func loadCommunitiesFailure() async throws {
        let mockService = MockCommunityService(shouldFail: true)
        Container.shared.communityService.register { mockService }

        let viewModel = await CommunitiesViewModel()
        #expect(await viewModel.errorMessage == nil)

        await viewModel.loadCommunities()

        #expect(await viewModel.communities.isEmpty)
        #expect(await viewModel.errorMessage == "Something went wrong. Please try again later")
    }
}

// MARK: CommunityViewModelTests.MockCommunityService

extension CommunityViewModelTests {
    private struct MockCommunityService: CommunityServiceProtocol {
        var expectedCommunities: [Community] = []
        var shouldFail = false

        func fetchCommunities() async throws -> [Community] {
            if shouldFail {
                throw MockError.someError
            }
            return expectedCommunities
        }
    }
}
