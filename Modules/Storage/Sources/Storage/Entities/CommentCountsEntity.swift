import CoreData
import Foundation
import Models
import Principle

// MARK: - CommentCountsEntity

@objc(CommentCountsEntity)
public class CommentCountsEntity: NSManagedObject {
  @nonobjc
  public class func fetchRequest() -> NSFetchRequest<CommentCountsEntity> {
    NSFetchRequest<CommentCountsEntity>(entityName: "CommentCountsEntity")
  }

  @NSManaged public var commentID: Int
  @NSManaged public var score: Int
  @NSManaged public var upvotes: Int
  @NSManaged public var publishedAt: String
  @NSManaged public var childCount: Int
  @NSManaged public var comment: CommentEntity?
}

// MARK: Identifiable

extension CommentCountsEntity: Identifiable { }

// MARK: ReadOnlyConvertible

extension CommentCountsEntity: ReadOnlyConvertible {
  public func toReadOnly() -> Models.CommentCounts {
    Models.CommentCounts(commentID: commentID, score: score, upvotes: upvotes, published: publishedAt, childCount: childCount)
  }
}

// MARK: SyncableEntity

extension CommentCountsEntity: SyncableEntity {
  public static func predicateForModel(_ model: Models.CommentCounts) -> NSPredicate {
    \CommentCountsEntity.commentID == model.commentID
  }

  public func updateEntityFrom(_ model: Models.CommentCounts, on _: StorageType) throws {
    score = model.score
    upvotes = model.upvotes
    childCount = model.childCount
  }

  public func populateEntityFrom(_ model: CommentCounts, on _: any StorageType) throws {
    CoreDataPopulator.populateFromModel(model, toEntity: self, nameMapping: [
      "published": "publishedAt",
    ])
  }
}
