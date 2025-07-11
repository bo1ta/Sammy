import Models
import Networking
import Storage

// MARK: - UserDataProviderProtocol

public protocol UserDataProviderProtocol: Sendable {
    func getCurrent() async throws -> Models.PersonAttributes?
    func getLocalUser() async throws -> Models.LocalUser?
}

// MARK: - UserDataProvider

public struct UserDataProvider: UserDataProviderProtocol, DataProvider, @unchecked Sendable {
    private let service: UserServiceProtocol
    private let siteService: SiteServiceProtocol
    private let currentUserProvider: CurrentUserProviderProtocol

    public init(
        service: UserServiceProtocol = UserService(),
        siteService: SiteServiceProtocol = SiteService(),
        currentUserProvider: CurrentUserProviderProtocol = CurrentUserProvider.instance)
    {
        self.service = service
        self.siteService = siteService
        self.currentUserProvider = currentUserProvider
    }

    public func getCurrent() async throws -> Models.PersonAttributes? {
        guard let personID = currentUserProvider.currentPersonID else {
            return nil
        }

        if let localPerson = await readOnlyStore.personByID(personID) {
            return localPerson
        }

        let remotePerson = try await service.getPersonDetails(queryOptions: [.personID(personID)])
        try await writeOnlyStore.synchronize(remotePerson.personProfile.person, ofType: PersonAttributesEntity.self)
        return remotePerson.personProfile.person
    }

    public func getLocalUser() async throws -> Models.LocalUser? {
        guard let personID = currentUserProvider.currentPersonID else {
            return nil
        }

        if let localUser = await readOnlyStore.localUserByPersonID(personID) {
            return localUser
        }

        let remoteLocalUser = try await siteService.getSite().myUser.localUser
        try await writeOnlyStore.synchronize(remoteLocalUser, ofType: LocalUserEntity.self)
        return remoteLocalUser
    }
}
