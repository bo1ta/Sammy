import CoreData
import Foundation
import Models
import Principle

// MARK: - CommentAttributesEntity

@objc(CommentAttributesEntity)
public class CommentAttributesEntity: NSManagedObject {
    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<CommentAttributesEntity> {
        NSFetchRequest<CommentAttributesEntity>(entityName: "CommentAttributesEntity")
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
    @NSManaged public var comment: CommentEntity?
}

// MARK: Identifiable

extension CommentAttributesEntity: Identifiable { }

// MARK: ReadOnlyConvertible

extension CommentAttributesEntity: ReadOnlyConvertible {
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

extension CommentAttributesEntity: SyncableEntity {
    public static func predicateForModel(_ model: Models.CommentAttributes) -> NSPredicate {
        \CommentAttributesEntity.uniqueID == model.id
    }

    public func updateEntityFrom(_ model: Models.CommentAttributes, on _: StorageType) throws {
        updatedAt = model.updated
        isRemoved = model.removed
        isCommentDeleted = model.deleted
        isLocal = model.local
        commentPath = model.path
        isDistinguished = model.distinguished
    }

    public func populateEntityFrom(_ model: Models.CommentAttributes, on _: StorageType) throws {
        self.uniqueID = model.id
        self.creatorID = model.creatorID
        self.postID = model.postID
        self.content = model.content
        self.languageID = model.languageID
        self.isRemoved = model.removed
        self.publishedAt = model.published
        self.updatedAt = model.updated
        self.isCommentDeleted = model.deleted
        self.isLocal = model.local
        self.commentPath = model.path
        self.isDistinguished = model.distinguished
    }
}
