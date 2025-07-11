import CoreData
import Foundation
import Models
import Principle

// MARK: - PersonProfileEntity

@objc(PersonProfileEntity)
public class PersonProfileEntity: NSManagedObject {
    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<PersonProfileEntity> {
        NSFetchRequest<PersonProfileEntity>(entityName: "PersonProfileEntity")
    }

    @NSManaged public var isAdmin: Bool
    @NSManaged public var personAttributes: PersonAttributesEntity
    @NSManaged public var personCounts: PersonCountsEntity

}

// MARK: Identifiable

extension PersonProfileEntity: Identifiable { }

// MARK: ReadOnlyConvertible

extension PersonProfileEntity: ReadOnlyConvertible {
    public func toReadOnly() -> Models.PersonProfile {
        Models.PersonProfile(person: personAttributes.toReadOnly(), personCounts: personCounts.toReadOnly(), isAdmin: isAdmin)
    }
}

// MARK: SyncableEntity

extension PersonProfileEntity: SyncableEntity {
    public static func predicateForModel(_ model: Models.PersonProfile) -> NSPredicate {
        \PersonProfileEntity.personAttributes.uniqueID == model.person.id
    }

    public func updateEntityFrom(_ model: Models.PersonProfile, on storage: StorageType) throws {
        _ = try personAttributes.updateEntityFrom(model.person, on: storage)
        _ = try personCounts.updateEntityFrom(model.personCounts, on: storage)
    }

    public func populateEntityFrom(_ model: PersonProfile, on storage: any StorageType) throws {
        self.isAdmin = isAdmin
        self.personAttributes = storage.findOrInsert(
            of: PersonAttributesEntity.self,
            using: PersonAttributesEntity.predicateForModel(model.person))
        self.personCounts = storage.findOrInsert(
            of: PersonCountsEntity.self,
            using: PersonCountsEntity.predicateForModel(model.personCounts))
    }
}
