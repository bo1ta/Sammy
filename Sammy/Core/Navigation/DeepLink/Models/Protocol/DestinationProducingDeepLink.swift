import Foundation

protocol DestinationProducingDeepLink {
  static var host: String { get }

  init()

  func navigationDestinations(from components: URLComponents) async -> NavigationType
}
