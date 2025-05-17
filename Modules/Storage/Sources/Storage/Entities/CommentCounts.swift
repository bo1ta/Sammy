import CoreData
import Foundation
import Models
import Principle

// MARK: - CommentCounts

@objc(CommentCounts)
public class CommentCounts: NSManagedObject {
    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<CommentCounts> {
        NSFetchRequest<CommentCounts>(entityName: "CommentCounts")
    }

    @NSManaged public var commentID: Int
    @NSManaged public var score: Int
    @NSManaged public var upvotes: Int
    @NSManaged public var publishedAt: String
    @NSManaged public var childCount: Int
    @NSManaged public var comment: Comment?
}

// MARK: Identifiable

extension CommentCounts: Identifiable { }

// MARK: ReadOnlyConvertible

extension CommentCounts: ReadOnlyConvertible {
    public func toReadOnly() -> Models.CommentCounts {
        Models.CommentCounts(commentID: commentID, score: score, upvotes: upvotes, published: publishedAt, childCount: childCount)
    }
}

// MARK: SyncableEntity

extension CommentCounts: SyncableEntity {
    public static func predicateForModel(_ model: Models.CommentCounts) -> NSPredicate {
        \CommentCounts.commentID == model.commentID
    }

    public func updateEntityFrom(_ model: Models.CommentCounts) throws -> Self {
        score = model.score
        upvotes = model.upvotes
        childCount = model.childCount
        return self
    }
}

// MARK: - Models.CommentCounts + Storable

extension Models.CommentCounts: Storable {
    public func toEntity(in context: NSManagedObjectContext) throws -> CommentCounts {
        let entity = CommentCounts(context: context)
        return CoreDataPopulator.populateFromModel(self, toEntity: entity, nameMapping: [:])
    }
}
