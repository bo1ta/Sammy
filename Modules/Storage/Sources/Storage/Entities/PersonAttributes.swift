import CoreData
import Foundation
import Models
import Principle

// MARK: - Person

@objc(Person)
public final class Person: NSManagedObject {
    @nonobjc
    public static func fetchRequest() -> NSFetchRequest<Person> {
        NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var uniqueID: Int
    @NSManaged public var name: String
    @NSManaged public var displayName: String?
    @NSManaged public var avatar: String?
    @NSManaged public var banned: NSNumber
    @NSManaged public var published: String
    @NSManaged public var dateUpdated: String?
    @NSManaged public var actorID: String
    @NSManaged public var bio: String?
    @NSManaged public var local: NSNumber
    @NSManaged public var banner: String?
    @NSManaged public var isPersonDeleted: NSNumber
    @NSManaged public var matrixUserID: String?
    @NSManaged public var botAccount: NSNumber
    @NSManaged public var banExpires: String?
    @NSManaged public var instanceID: Int
}

// MARK: Identifiable

extension Person: Identifiable { }

// MARK: ReadOnlyConvertible

extension Person: ReadOnlyConvertible {
    public func toReadOnly() -> Models.PersonAttributes {
        Models.PersonAttributes(
            id: uniqueID,
            name: name,
            displayName: displayName,
            avatar: avatar,
            banned: banned.boolValue,
            published: published,
            updated: dateUpdated,
            actorID: actorID,
            bio: bio,
            local: local.boolValue,
            banner: banner,
            deleted: isPersonDeleted.boolValue,
            matrixUserID: matrixUserID,
            botAccount: botAccount.boolValue,
            banExpires: banExpires,
            instanceID: instanceID)
    }
}

// MARK: SyncableEntity

extension Person: SyncableEntity {
    public static func predicateForModel(_ model: Models.PersonAttributes) -> NSPredicate {
        \Person.uniqueID == model.id
    }

    public func updateEntityFrom(_ model: Models.PersonAttributes) throws -> Self {
        self.dateUpdated = model.updated
        self.bio = model.bio
        self.banner = model.banner
        self.isPersonDeleted = model.deleted as NSNumber
        self.banned = model.banned as NSNumber
        self.published = model.published

        return self
    }
}

// MARK: - Models.PersonAttributes + Storable

extension Models.PersonAttributes: Storable {
    @discardableResult
    public func toEntity(in context: NSManagedObjectContext) throws -> Person {
        let entity = Person(context: context)
        let modelToEntityMapping: [String: String] = [
            "id": "uniqueID",
            "updated": "dateUpdated",
            "deleted": "isPersonDeleted",
        ]

        CoreDataPopulator.populateFromModel(self, toEntity: entity, nameMapping: modelToEntityMapping)
        return entity
    }
}
