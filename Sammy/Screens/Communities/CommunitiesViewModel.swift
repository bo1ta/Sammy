import Foundation
import Models
import Networking
import OSLog

@Observable
@MainActor
final class CommunitiesViewModel {

  // MARK: - Dependencies

  private let service: CommunityServiceProtocol
  private let logger = Logger(subsystem: "com.Sammy", category: "CommunitiesViewModel")

  // MARK: - Observed Properties

  private(set) var communities: [Community] = []
  private(set) var errorMessage: String?

  var searchText = ""
  var currentTab = CommunityTabs.myCommunities

  init(service: CommunityServiceProtocol = CommunityService()) {
    self.service = service
  }

  // MARK: - Public methods

  func loadCommunities() async {
    SammyWrapper.showLoading()
    defer { SammyWrapper.hideLoading() }

    do {
      communities = try await service.fetchCommunities()
    } catch {
      logger.error("Error loading communities. Error: \(error.localizedDescription)")
      errorMessage = "Something went wrong. Please try again later"
    }
  }
}
