import FactoryTesting
import Testing
@testable import Factory
@testable import Models
@testable import Networking
@testable import Sammy

// MARK: - CommunityViewModelTests

@Suite(.serialized)
struct CommunityViewModelTests {
    @Test
    func loadCommunitiesSuccess() async throws {
        let mockCommunity = CommunityFactory.create()

        Container.shared.communityService.register {
            MockCommunityService(expectedCommunities: [mockCommunity])
        }
        defer { Container.shared.communityService.reset() }

        let viewModel = await CommunitiesViewModel()
        #expect(await viewModel.communities.isEmpty)

        await viewModel.loadCommunities()
        #expect(await viewModel.communities.first == mockCommunity)
        #expect(await viewModel.errorMessage == nil)
    }

    @Test
    func loadCommunitiesFailure() async throws {
        Container.shared.communityService.register {
            MockCommunityService(shouldFail: true)
        }
        defer {
            Container.shared.communityService.reset()
        }

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
