import Foundation
@testable import Networking

struct MockAPIProvider: APIProvider {
  var expectedData: Data?

  func dispatch(_: APIRequest) async throws -> Data {
    expectedData ?? Data()
  }
}
