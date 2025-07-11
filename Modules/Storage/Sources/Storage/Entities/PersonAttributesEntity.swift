import CoreData
import Foundation
import Models

// MARK: - PersonAttributesEntity

@objc(PersonAttributesEntity)
public class PersonAttributesEntity: NSManagedObject {
    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<PersonAttributesEntity> {
        NSFetchRequest<PersonAttributesEntity>(entityName: "PersonAttributesEntity")
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
    @NSManaged public var personProfile: PersonProfileEntity?
    @NSManaged public var comments: Set<CommentEntity>?
    @NSManaged public var posts: PostEntity?
    @NSManaged public var localUser: LocalUserEntity?
    @NSManaged public var personModerates: PersonModeratesEntity?
}

// MARK: Generated accessors for comments
extension PersonAttributesEntity {

    @objc(addCommentsObject:)
    @NSManaged
    public func addToComments(_ value: CommentEntity)

    @objc(removeCommentsObject:)
    @NSManaged
    public func removeFromComments(_ value: CommentEntity)

    @objc(addComments:)
    @NSManaged
    public func addToComments(_ values: Set<CommentEntity>)

    @objc(removeComments:)
    @NSManaged
    public func removeFromComments(_ values: Set<CommentEntity>)

}

// MARK: Identifiable

extension PersonAttributesEntity: Identifiable { }

// MARK: ReadOnlyConvertible

extension PersonAttributesEntity: ReadOnlyConvertible {
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

extension PersonAttributesEntity: SyncableEntity {
    public static func predicateForModel(_ model: Models.PersonAttributes) -> NSPredicate {
        \PersonAttributesEntity.uniqueID == model.id
    }

    public func updateEntityFrom(_ model: Models.PersonAttributes, on _: StorageType) throws {
        self.dateUpdated = model.updated
        self.bio = model.bio
        self.banner = model.banner
        self.isPersonDeleted = model.deleted as NSNumber
        self.banned = model.banned as NSNumber
        self.published = model.published
    }

    public func populateEntityFrom(_ model: PersonAttributes, on _: any StorageType) throws {
        let modelToEntityMapping: [String: String] = [
            "id": "uniqueID",
            "updated": "dateUpdated",
            "deleted": "isPersonDeleted",
        ]

        CoreDataPopulator.populateFromModel(model, toEntity: self, nameMapping: modelToEntityMapping)
    }
}
