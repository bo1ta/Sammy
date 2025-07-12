import Testing
@testable import Models
@testable import Networking
@testable import Sammy
@testable import Storage

// MARK: - CommunityViewModelTests

@Suite
class CommunityViewModelTests {
  @Test
  func loadCommunitiesSuccess() async throws {
    let mockCommunity = CommunityFactory.create()

    let viewModel = await CommunitiesViewModel(service: MockCommunityService(expectedCommunities: [mockCommunity]))
    #expect(await viewModel.communities.isEmpty)

    await viewModel.loadCommunities()
    #expect(await viewModel.communities.first == mockCommunity)
    #expect(await viewModel.errorMessage == nil)
  }

  @Test
  func loadCommunitiesFailure() async throws {
    let viewModel = await CommunitiesViewModel(service: MockCommunityService(shouldFail: true))
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
