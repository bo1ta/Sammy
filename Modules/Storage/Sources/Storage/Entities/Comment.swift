import CoreData
import Foundation
import Models
import Principle

// MARK: - Comment

@objc(Comment)
public class Comment: NSManagedObject {
    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<Comment> {
        NSFetchRequest<Comment>(entityName: "Comment")
    }

    @NSManaged public var commentID: Int
    @NSManaged public var commentAttributes: CommentAttributes
    @NSManaged public var creatorAttributes: PersonAttributes
    @NSManaged public var postAttributes: PostAttributes
    @NSManaged public var communityAttributes: CommunityAttributes
    @NSManaged public var commentCounts: CommentCounts
}

// MARK: Identifiable

extension Comment: Identifiable { }

// MARK: ReadOnlyConvertible

extension Comment: ReadOnlyConvertible {
    public func toReadOnly() -> Models.Comment {
        Models
            .Comment(
                commentAttributes: commentAttributes.toReadOnly(),
                creator: creatorAttributes.toReadOnly(),
                postData: postAttributes.toReadOnly(),
                communityAttributes: communityAttributes.toReadOnly(),
                countsData: commentCounts.toReadOnly())
    }
}

// MARK: SyncableEntity

extension Comment: SyncableEntity {
    public static func predicateForModel(_ model: Models.Comment) -> NSPredicate {
        \Comment.commentAttributes.uniqueID == model.commentAttributes.id
    }

    public func updateEntityFrom(_ model: Models.Comment) throws -> Self {
        _ = try commentAttributes.updateEntityFrom(model.commentAttributes)
        _ = try creatorAttributes.updateEntityFrom(model.creator)
        _ = try postAttributes.updateEntityFrom(model.postData)
        _ = try communityAttributes.updateEntityFrom(model.communityAttributes)
        _ = try commentCounts.updateEntityFrom(model.countsData)

        return self
    }
}

// MARK: - Models.Comment + Storable

extension Models.Comment: Storable {
    public func toEntity(in context: NSManagedObjectContext) throws -> Comment {
        let entity = Comment(context: context)
        entity.commentID = commentAttributes.id

        entity.commentCounts = try CommentCounts.findOrInsert(model: countsData, on: context)
        entity.commentAttributes = try CommentAttributes.findOrInsert(model: commentAttributes, on: context)
        entity.postAttributes = try PostAttributes.findOrInsert(model: postData, on: context)
        entity.creatorAttributes = try PersonAttributes.findOrInsert(model: creator, on: context)
        entity.communityAttributes = try CommunityAttributes.findOrInsert(model: communityAttributes, on: context)
        return entity
    }
}

extension NSManagedObject {
    public convenience init(context: NSManagedObjectContext) {
        let name = String(describing: type(of: self))
        let entity = NSEntityDescription.entity(forEntityName: name, in: context)!
        self.init(entity: entity, insertInto: context)
    }
}
