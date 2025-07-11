import CoreData
import Foundation
import Models
import Principle

// MARK: - PostAttributesEntity

@objc(PostAttributesEntity)
public class PostAttributesEntity: NSManagedObject {
    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<PostAttributesEntity> {
        NSFetchRequest<PostAttributesEntity>(entityName: "PostAttributesEntity")
    }

    @NSManaged public var uniqueID: Int
    @NSManaged public var name: String
    @NSManaged public var url: String?
    @NSManaged public var body: String?
    @NSManaged public var creatorID: Int
    @NSManaged public var communityID: Int
    @NSManaged public var publishedAt: String
    @NSManaged public var comments: Set<CommentEntity>?
    @NSManaged public var post: PostEntity?
}

// MARK: Generated accessors for comments
extension PostAttributesEntity {

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

extension PostAttributesEntity: Identifiable { }

// MARK: ReadOnlyConvertible

extension PostAttributesEntity: ReadOnlyConvertible {
    public func toReadOnly() -> Models.PostAttributes {
        Models
            .PostAttributes(
                id: uniqueID,
                name: name,
                url: url,
                body: body,
                creatorId: creatorID,
                communityId: communityID,
                published: publishedAt)
    }
}

// MARK: SyncableEntity

extension PostAttributesEntity: SyncableEntity {
    public static func predicateForModel(_ model: Models.PostAttributes) -> NSPredicate {
        \PostAttributesEntity.uniqueID == model.id
    }

    public func updateEntityFrom(_ model: PostAttributes, on _: StorageType) throws {
        self.body = model.body
    }

    public func populateEntityFrom(_ model: PostAttributes, on _: any StorageType) throws {
        self.uniqueID = model.id
        self.name = model.name
        self.url = model.url
        self.body = model.body
        self.creatorID = model.creatorId
        self.communityID = model.communityId
        self.publishedAt = model.published
    }
}
