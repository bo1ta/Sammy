import CoreData
import Foundation
import Models
import Principle

// MARK: - LocalUser

@objc(LocalUser)
public class LocalUser: NSManagedObject {

    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<LocalUser> {
        NSFetchRequest<LocalUser>(entityName: "LocalUser")
    }

    @NSManaged public var userID: Int
    @NSManaged public var personID: Int
    @NSManaged public var localUserAttributes: LocalUserAttributes
    @NSManaged public var personAttributes: PersonAttributes
}

// MARK: Identifiable

extension LocalUser: Identifiable { }

// MARK: ReadOnlyConvertible

extension LocalUser: ReadOnlyConvertible {
    public func toReadOnly() -> Models.LocalUser {
        Models.LocalUser(userAttributes: localUserAttributes.toReadOnly(), personAttributes: personAttributes.toReadOnly())
    }
}

// MARK: SyncableEntity

extension LocalUser: SyncableEntity {
    public static func predicateForModel(_ model: Models.LocalUser) -> NSPredicate {
        \LocalUser.userID == model.userAttributes.id && \LocalUser.personID == model.personAttributes.id
    }

    public func updateEntityFrom(_ model: Models.LocalUser) throws -> Self {
        try _ = localUserAttributes.updateEntityFrom(model.userAttributes)
        try _ = personAttributes.updateEntityFrom(model.personAttributes)
        return self
    }
}

// MARK: - Models.LocalUser + Storable

extension Models.LocalUser: Storable {
    public func toEntity(in context: NSManagedObjectContext) throws -> LocalUser {
        let entity = LocalUser(context: context)
        entity.localUserAttributes = try LocalUserAttributes.findOrInsert(model: userAttributes, on: context)
        entity.personAttributes = try PersonAttributes.findOrInsert(model: personAttributes, on: context)
        return entity
    }
}
