import Testing
@testable import Models
@testable import Networking
@testable import Sammy

@Suite("CommunityViewModelTests")
struct CommunityViewModelTests {
    @Test
    func loadCommunitiesSuccess() async throws {
        let mockCommunity = CommunityBuilder().build()
        var mockService = MockCommunityService()
        mockService.expectedCommunities = [mockCommunity]

        let viewModel = await CommunitiesViewModel(service: mockService)
        #expect(await viewModel.communities.isEmpty)

        await viewModel.loadCommunities()
        #expect(await viewModel.communities.first == mockCommunity)
        #expect(await viewModel.errorMessage == nil)
    }

    @Test
    func loadCommunitiesFailure() async throws {
        var mockService = MockCommunityService()
        mockService.shouldFail = true

        let viewModel = await CommunitiesViewModel(service: mockService)
        #expect(await viewModel.errorMessage == nil)

        await viewModel.loadCommunities()

        #expect(await viewModel.communities.isEmpty)
        #expect(await viewModel.errorMessage == "Something went wrong. Please try again later")
    }
}

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
