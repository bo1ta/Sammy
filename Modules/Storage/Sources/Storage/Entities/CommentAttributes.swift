import CoreData
import Foundation
import Models
import Principle

// MARK: - CommentAttributes

@objc(CommentAttributes)
public class CommentAttributes: NSManagedObject {
    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<CommentAttributes> {
        NSFetchRequest<CommentAttributes>(entityName: "CommentAttributes")
    }

    @NSManaged public var uniqueID: Int
    @NSManaged public var creatorID: Int
    @NSManaged public var postID: Int
    @NSManaged public var content: String
    @NSManaged public var isRemoved: Bool
    @NSManaged public var publishedAt: String
    @NSManaged public var updatedAt: String?
    @NSManaged public var isCommentDeleted: Bool
    @NSManaged public var isLocal: Bool
    @NSManaged public var commentPath: String
    @NSManaged public var isDistinguished: Bool
    @NSManaged public var languageID: Int
    @NSManaged public var comment: Comment?
}

// MARK: Identifiable

extension CommentAttributes: Identifiable { }

// MARK: ReadOnlyConvertible

extension CommentAttributes: ReadOnlyConvertible {
    public func toReadOnly() -> Models.CommentAttributes {
        Models
            .CommentAttributes(
                id: uniqueID,
                creatorID: creatorID,
                postID: postID,
                content: content,
                removed: isRemoved,
                published: publishedAt,
                updated: updatedAt,
                deleted: isDeleted,
                local: isLocal,
                path: commentPath,
                distinguished: isDistinguished,
                languageID: languageID)
    }
}

// MARK: SyncableEntity

extension CommentAttributes: SyncableEntity {
    public static func predicateForModel(_ model: Models.CommentAttributes) -> NSPredicate {
        \CommentAttributes.uniqueID == model.id
    }

    public func updateEntityFrom(_ model: Models.CommentAttributes) throws -> Self {
        updatedAt = model.updated
        isRemoved = model.removed
        isCommentDeleted = model.deleted
        isLocal = model.local
        commentPath = model.path
        isDistinguished = model.distinguished
        return self
    }
}

// MARK: - Models.CommentAttributes + Storable

extension Models.CommentAttributes: Storable {
    public func toEntity(in context: NSManagedObjectContext) throws -> CommentAttributes {
        let entity = CommentAttributes(context: context)
        entity.uniqueID = id
        entity.creatorID = creatorID
        entity.postID = postID
        entity.content = content
        entity.languageID = languageID
        entity.isRemoved = removed
        entity.publishedAt = published
        entity.updatedAt = updated
        entity.isCommentDeleted = deleted
        entity.isLocal = local
        entity.commentPath = path
        entity.isDistinguished = distinguished
        return entity
    }
}
