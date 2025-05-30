import Factory
import Models
import Networking
import Storage

// MARK: - UserRepositoryProtocol

public protocol UserRepositoryProtocol: Sendable {
    func getCurrent() async throws -> Models.PersonAttributes?
}

// MARK: - UserRepository

public struct UserRepository: UserRepositoryProtocol, @unchecked Sendable {
    @Injected(\.userService) private var service: UserServiceProtocol
    @Injected(\.currentUserProvider) private var currentUserProvider: CurrentUserProviderProtocol

    private let dataStore = DataStore<Storage.PersonAttributes>()

    public func getCurrent() async throws -> Models.PersonAttributes? {
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
