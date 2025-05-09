import CoreData
import Foundation
import Models

// MARK: - Person

@objc(Person)
public class Person: NSManagedObject {
    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<Person> {
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
    func toReadOnly() -> Models.PersonAttributes {
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

// MARK: - Models.Person + Storable

extension Models.PersonAttributes: Storable {
    @discardableResult
    func toEntity(in context: NSManagedObjectContext) throws -> Person {
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
