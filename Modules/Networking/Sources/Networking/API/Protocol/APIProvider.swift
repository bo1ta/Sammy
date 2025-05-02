import Foundation

public protocol APIProvider: Sendable {
    func dispatch(_ request: APIRequest) async throws -> Data
}
