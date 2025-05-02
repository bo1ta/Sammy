import Foundation
import Testing
@testable import Networking

// MARK: - PostServiceTests

@Suite
class UserServiceTests: SammyTestBase {
    @Test
    func register() async throws {
        let jsonData = try parseDataFromFile(name: "registerResponse")
        let mockAPI = MockAPIProvider(expectedData: jsonData)

        let service = UserService(client: mockAPI)
        let response = try await service.register(username: "blabla", password: "blablabla")
        #expect(response.jwt == "secret-jwt")
        #expect(response.registrationCreated == true)
        #expect(response.verifyEmailSent == true)
    }
}
