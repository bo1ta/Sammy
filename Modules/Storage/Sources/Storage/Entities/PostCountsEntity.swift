import CoreData
import Foundation
import Models
import Principle

// MARK: - PostCountsEntity

@objc(PostCountsEntity)
public class PostCountsEntity: NSManagedObject {
    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<PostCountsEntity> {
        NSFetchRequest<PostCountsEntity>(entityName: "PostCountsEntity")
    }

    @NSManaged public var postID: Int
    @NSManaged public var comments: Int
    @NSManaged public var score: Int
    @NSManaged public var upvotes: Int
    @NSManaged public var downvotes: Int
    @NSManaged public var publishedAt: String
    @NSManaged public var newestCommentTime: String
    @NSManaged public var post: PostEntity?

}

// MARK: Identifiable

extension PostCountsEntity: Identifiable { }

// MARK: ReadOnlyConvertible

extension PostCountsEntity: ReadOnlyConvertible {
    public func toReadOnly() -> Models.PostCounts {
        Models
            .PostCounts(
                postID: postID,
                comments: comments,
                score: score,
                upvotes: upvotes,
                downvotes: downvotes,
                published: publishedAt,
                newestCommentTime: newestCommentTime)
    }
}

// MARK: SyncableEntity

extension PostCountsEntity: SyncableEntity {
    public static func predicateForModel(_ model: Models.PostCounts) -> NSPredicate {
        \PostCountsEntity.postID == model.postID
    }

    public func updateEntityFrom(_ model: Models.PostCounts, on _: StorageType) throws {
        comments = model.comments
        score = model.score
        upvotes = model.upvotes
        downvotes = model.downvotes
        publishedAt = model.published
        newestCommentTime = model.newestCommentTime
    }

    public func populateEntityFrom(_ model: PostCounts, on _: any StorageType) throws {
        self.postID = model.postID
        self.comments = model.comments
        self.score = model.score
        self.upvotes = model.upvotes
        self.downvotes = model.downvotes
        self.publishedAt = model.published
        self.newestCommentTime = model.newestCommentTime
    }
}
