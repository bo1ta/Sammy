import Domain
import Foundation
import OSLog

struct PostDetailDeepLink: DestinationProducingDeepLink {
  static let host = "post-detail"

  private let logger = Logger()
  private let dataProvider: PostDataProviderProtocol

  init() {
    self.init(dataProvider: PostDataProvider())
  }

  init(dataProvider: PostDataProviderProtocol) {
    self.dataProvider = dataProvider
  }

  func navigationDestinations(from components: URLComponents) async -> NavigationType {
    guard
      let idString = components.url?.lastPathComponent as? String,
      let postID = Int(idString)
    else {
      logger.error("Invalid post detail deep link format: \(components)")
      return .none
    }

    do {
      let post = try await dataProvider.getByID(postID)
      return .navigate([HomeDestinations.postDetail(post)])
    } catch {
      logger.error("Error fetching post by ID: \(error)")
    }

    logger.error("Post with ID \(postID) not found.")
    return .none
  }
}
