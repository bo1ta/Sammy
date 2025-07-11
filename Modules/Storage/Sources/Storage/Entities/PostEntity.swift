import CoreData
import Foundation
import Models
import Principle

// MARK: - PostEntity

@objc(PostEntity)
public class PostEntity: NSManagedObject {
    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<PostEntity> {
        NSFetchRequest<PostEntity>(entityName: "PostEntity")
    }

    @NSManaged public var postAttributes: PostAttributesEntity
    @NSManaged public var creatorAttributes: PersonAttributesEntity
    @NSManaged public var postCounts: PostCountsEntity
    @NSManaged public var communityAttributes: CommunityAttributesEntity
}

// MARK: Identifiable

extension PostEntity: Identifiable { }

// MARK: ReadOnlyConvertible

extension PostEntity: ReadOnlyConvertible {
    public func toReadOnly() -> Models.Post {
        Models.Post(
            postData: postAttributes.toReadOnly(),
            creatorData: creatorAttributes.toReadOnly(),
            postCounts: postCounts.toReadOnly(),
            communityAttributes: communityAttributes.toReadOnly())
    }
}

// MARK: SyncableEntity

extension PostEntity: SyncableEntity {
    public static func predicateForModel(_ model: Models.Post) -> NSPredicate {
        \PostEntity.postAttributes.uniqueID == model.attributes.id
    }

    public func updateEntityFrom(_ model: Models.Post, on storage: StorageType) throws {
        _ = try postAttributes.updateEntityFrom(model.attributes, on: storage)
        _ = try creatorAttributes.updateEntityFrom(model.creator, on: storage)
        _ = try postCounts.updateEntityFrom(model.postCounts, on: storage)
        _ = try communityAttributes.updateEntityFrom(model.communityAttributes, on: storage)
    }

    public func populateEntityFrom(_ model: Post, on storage: any StorageType) throws {
        self.postAttributes = try storage.findOrInsert(
            of: PostAttributesEntity.self,
            usingDTO: model.attributes)
        self.creatorAttributes = try storage.findOrInsert(
            of: PersonAttributesEntity.self,
            usingDTO: model.creator)
        self.postCounts = try storage.findOrInsert(
            of: PostCountsEntity.self,
            usingDTO: model.postCounts)
        self.communityAttributes = try storage.findOrInsert(
            of: CommunityAttributesEntity.self,
            usingDTO: model.communityAttributes)
    }
}
