import CoreData
import Foundation
import Models

// MARK: - PersonAttributes

@objc(PersonAttributes)
public class PersonAttributes: NSManagedObject {
    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<PersonAttributes> {
        NSFetchRequest<PersonAttributes>(entityName: "PersonAttributes")
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
    @NSManaged public var personProfile: PersonProfile?
    @NSManaged public var comments: NSSet?
    @NSManaged public var posts: Post?
    @NSManaged public var localUser: LocalUser?
    @NSManaged public var personModerates: PersonModerates?
}

// MARK: Generated accessors for comments
extension PersonAttributes {

    @objc(addCommentsObject:)
    @NSManaged
    public func addToComments(_ value: Comment)

    @objc(removeCommentsObject:)
    @NSManaged
    public func removeFromComments(_ value: Comment)

    @objc(addComments:)
    @NSManaged
    public func addToComments(_ values: NSSet)

    @objc(removeComments:)
    @NSManaged
    public func removeFromComments(_ values: NSSet)

}

// MARK: Identifiable

extension PersonAttributes: Identifiable { }

// MARK: ReadOnlyConvertible

extension PersonAttributes: ReadOnlyConvertible {
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

extension PersonAttributes: SyncableEntity {
    public static func predicateForModel(_ model: Models.PersonAttributes) -> NSPredicate {
        \PersonAttributes.uniqueID == model.id
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
    public func toEntity(in context: NSManagedObjectContext) throws -> PersonAttributes {
        let entity = PersonAttributes(context: context)
        let modelToEntityMapping: [String: String] = [
            "id": "uniqueID",
            "updated": "dateUpdated",
            "deleted": "isPersonDeleted",
        ]

        return CoreDataPopulator.populateFromModel(self, toEntity: entity, nameMapping: modelToEntityMapping)
    }
}
