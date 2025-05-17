import CoreData
import Foundation
import Models
import Principle

// MARK: - PostAttributes

@objc(PostAttributes)
public class PostAttributes: NSManagedObject {
    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<PostAttributes> {
        NSFetchRequest<PostAttributes>(entityName: "PostAttributes")
    }

    @NSManaged public var uniqueID: Int
    @NSManaged public var name: String
    @NSManaged public var url: String?
    @NSManaged public var body: String?
    @NSManaged public var creatorID: Int
    @NSManaged public var communityID: Int
    @NSManaged public var publishedAt: String
    @NSManaged public var comments: NSSet?
    @NSManaged public var post: Post?
}

// MARK: Generated accessors for comments
extension PostAttributes {

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

extension PostAttributes: Identifiable { }

// MARK: ReadOnlyConvertible

extension PostAttributes: ReadOnlyConvertible {
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

extension PostAttributes: SyncableEntity {
    public static func predicateForModel(_ model: Models.PostAttributes) -> NSPredicate {
        \PostAttributes.uniqueID == model.id
    }

    public func updateEntityFrom(_ model: Models.PostAttributes) throws -> Self {
        self.body = model.body
        return self
    }
}

// MARK: - Models.PostAttributes + Storable

extension Models.PostAttributes: Storable {
    public func toEntity(in context: NSManagedObjectContext) throws -> PostAttributes {
        let entity = PostAttributes(context: context)
        entity.uniqueID = id
        entity.name = name
        entity.url = url
        entity.body = body
        entity.creatorID = creatorId
        entity.communityID = communityId
        entity.publishedAt = published
        return entity
    }
}
