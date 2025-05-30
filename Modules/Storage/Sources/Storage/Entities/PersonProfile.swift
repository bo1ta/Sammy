import CoreData
import Foundation
import Models
import Principle

// MARK: - PersonProfile

@objc(PersonProfile)
public class PersonProfile: NSManagedObject {
    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<PersonProfile> {
        NSFetchRequest<PersonProfile>(entityName: "PersonProfile")
    }

    @NSManaged public var isAdmin: Bool
    @NSManaged public var personAttributes: PersonAttributes
    @NSManaged public var personCounts: PersonCounts

}

// MARK: Identifiable

extension PersonProfile: Identifiable { }

// MARK: ReadOnlyConvertible

extension PersonProfile: ReadOnlyConvertible {
    public func toReadOnly() -> Models.PersonProfile {
        Models.PersonProfile(person: personAttributes.toReadOnly(), personCounts: personCounts.toReadOnly(), isAdmin: isAdmin)
    }
}

// MARK: - Models.PersonProfile + Storable

extension Models.PersonProfile: Storable {
    public func toEntity(in context: NSManagedObjectContext) throws -> PersonProfile {
        let entity = PersonProfile(context: context)
        entity.isAdmin = isAdmin
        entity.personAttributes = try PersonAttributes.findOrInsert(model: person, on: context)
        entity.personCounts = try PersonCounts.findOrInsert(model: personCounts, on: context)
        return entity
    }
}

// MARK: - PersonProfile + SyncableEntity

extension PersonProfile: SyncableEntity {
    public static func predicateForModel(_ model: Models.PersonProfile) -> NSPredicate {
        \PersonProfile.personAttributes.uniqueID == model.person.id
    }

    public func updateEntityFrom(_ model: Models.PersonProfile) throws -> PersonProfile {
        _ = try personAttributes.updateEntityFrom(model.person)
        _ = try personCounts.updateEntityFrom(model.personCounts)
        return self
    }
}
