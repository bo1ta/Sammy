import Factory
import Models
import Networking
import Storage

// MARK: - UserRepositoryProtocol

public protocol UserRepositoryProtocol: Sendable {
    func getCurrent() async throws -> Models.PersonAttributes?
    func getLocalUser() async throws -> Models.LocalUser?
}

// MARK: - UserRepository

public struct UserRepository: UserRepositoryProtocol, @unchecked Sendable {
    @Injected(\.userService) private var service: UserServiceProtocol
    @Injected(\.siteService) private var siteService: SiteServiceProtocol
    @Injected(\.currentUserProvider) private var currentUserProvider: CurrentUserProviderProtocol

    public func getCurrent() async throws -> Models.PersonAttributes? {
        guard let personID = currentUserProvider.currentPersonID else {
            return nil
        }

        let dataStore = DataStore<Storage.PersonAttributes>()

        if let localPerson = await dataStore.first(where: \.uniqueID == personID) {
            return localPerson
        }

        let remotePerson = try await service.getPersonDetails(queryOptions: [.personID(personID)])
        return remotePerson.personProfile.person
    }

    public func getLocalUser() async throws -> Models.LocalUser? {
        guard let personID = currentUserProvider.currentPersonID else {
            return nil
        }

        let dataStore = DataStore<Storage.LocalUser>()
        if let localUser = await dataStore.first(where: \.personAttributes.uniqueID == personID) {
            return localUser
        }

        let remoteLocalUser = try await siteService.getSite().myUser.localUser
        try await dataStore.importModel(remoteLocalUser)
        return remoteLocalUser
    }
}
