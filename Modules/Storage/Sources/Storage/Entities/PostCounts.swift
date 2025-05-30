import CoreData
import Foundation
import Models
import Principle

// MARK: - PostCounts

@objc(PostCounts)
public class PostCounts: NSManagedObject {
    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<PostCounts> {
        NSFetchRequest<PostCounts>(entityName: "PostCounts")
    }

    @NSManaged public var postID: Int
    @NSManaged public var comments: Int
    @NSManaged public var score: Int
    @NSManaged public var upvotes: Int
    @NSManaged public var downvotes: Int
    @NSManaged public var publishedAt: String
    @NSManaged public var newestCommentTime: String
    @NSManaged public var post: Post?

}

// MARK: Identifiable

extension PostCounts: Identifiable { }

// MARK: ReadOnlyConvertible

extension PostCounts: ReadOnlyConvertible {
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

extension PostCounts: SyncableEntity {
    public static func predicateForModel(_ model: Models.PostCounts) -> NSPredicate {
        \PostCounts.postID == model.postID
    }

    public func updateEntityFrom(_ model: Models.PostCounts) throws -> Self {
        comments = model.comments
        score = model.score
        upvotes = model.upvotes
        downvotes = model.downvotes
        publishedAt = model.published
        newestCommentTime = model.newestCommentTime
        return self
    }
}

// MARK: - Models.PostCounts + Storable

extension Models.PostCounts: Storable {
    public func toEntity(in context: NSManagedObjectContext) throws -> PostCounts {
        let entity = PostCounts(context: context)
        entity.postID = postID
        entity.comments = comments
        entity.score = score
        entity.upvotes = upvotes
        entity.downvotes = downvotes
        entity.publishedAt = published
        entity.newestCommentTime = newestCommentTime
        return entity
    }
}
