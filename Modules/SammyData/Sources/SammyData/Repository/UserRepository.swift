import Factory
import Models
import Networking
import Storage

// MARK: - UserRepositoryProtocol

public protocol UserRepositoryProtocol: Sendable {
    func getCurrent() async throws -> PersonAttributes?
}

// MARK: - UserRepository

public struct UserRepository: UserRepositoryProtocol, @unchecked Sendable {
    @Injected(\.userService) private var service: UserServiceProtocol
    @Injected(\.currentUserProvider) private var currentUserProvider: CurrentUserManagerProtocol

    private let dataStore = DataStore<Person>()

    public func getCurrent() async throws -> PersonAttributes? {
        guard let personID = currentUserProvider.currentPersonID else {
            return nil
        }

        if let localPerson = await dataStore.first(where: \.uniqueID == personID) {
            return localPerson
        }

        let remotePerson = try await service.getPersonDetails(queryOptions: [.personID(personID)])
        return remotePerson.personProfile.person
    }
}
