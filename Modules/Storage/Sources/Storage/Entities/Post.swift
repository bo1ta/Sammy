import CoreData
import Foundation
import Models
import Principle

// MARK: - Post

@objc(Post)
public class Post: NSManagedObject {
    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<Post> {
        NSFetchRequest<Post>(entityName: "Post")
    }

    @NSManaged public var postID: Int
    @NSManaged public var postAttributes: PostAttributes
    @NSManaged public var creatorAttributes: PersonAttributes
    @NSManaged public var postCounts: PostCounts
    @NSManaged public var communityAttributes: CommunityAttributes
}

// MARK: Identifiable

extension Post: Identifiable { }

// MARK: ReadOnlyConvertible

extension Post: ReadOnlyConvertible {
    public func toReadOnly() -> Models.Post {
        Models.Post(
            postData: postAttributes.toReadOnly(),
            creatorData: creatorAttributes.toReadOnly(),
            postCounts: postCounts.toReadOnly(),
            communityAttributes: communityAttributes.toReadOnly())
    }
}

// MARK: - Models.Post + Storable

extension Models.Post: Storable {
    public func toEntity(in context: NSManagedObjectContext) throws -> Post {
        let entity = Post(context: context)
        entity.postID = postData.id
        entity.postAttributes = try PostAttributes.findOrInsert(model: postData, on: context)
        entity.creatorAttributes = try PersonAttributes.findOrInsert(model: creator, on: context)
        entity.postCounts = try PostCounts.findOrInsert(model: postCounts, on: context)
        entity.communityAttributes = try CommunityAttributes.findOrInsert(model: communityAttributes, on: context)
        return entity
    }
}

// MARK: - Post + SyncableEntity

extension Post: SyncableEntity {
    public static func predicateForModel(_ model: Models.Post) -> NSPredicate {
        \Post.postID == model.postData.id
    }

    public func updateEntityFrom(_ model: Models.Post) throws -> Post {
        _ = try postAttributes.updateEntityFrom(model.postData)
        _ = try creatorAttributes.updateEntityFrom(model.creator)
        _ = try postCounts.updateEntityFrom(model.postCounts)
        _ = try communityAttributes.updateEntityFrom(model.communityAttributes)
        return self
    }
}
