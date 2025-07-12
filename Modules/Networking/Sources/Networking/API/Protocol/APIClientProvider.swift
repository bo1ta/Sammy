import Foundation

public protocol APIClientProvider: Sendable {
  func dispatch(_ request: APIRequest) async throws -> Data
}
