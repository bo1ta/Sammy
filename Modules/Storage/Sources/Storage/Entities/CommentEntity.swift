import CoreData
import Foundation
import Models
import Principle

// MARK: - CommentEntity

@objc(CommentEntity)
public class CommentEntity: NSManagedObject {
  @nonobjc
  public class func fetchRequest() -> NSFetchRequest<CommentEntity> {
    NSFetchRequest<CommentEntity>(entityName: "CommentEntity")
  }

  @NSManaged public var commentID: Int
  @NSManaged public var commentAttributes: CommentAttributesEntity
  @NSManaged public var creatorAttributes: PersonAttributesEntity
  @NSManaged public var postAttributes: PostAttributesEntity
  @NSManaged public var communityAttributes: CommunityAttributesEntity
  @NSManaged public var commentCounts: CommentCountsEntity
}

// MARK: Identifiable

extension CommentEntity: Identifiable { }

// MARK: ReadOnlyConvertible

extension CommentEntity: ReadOnlyConvertible {
  public func toReadOnly() -> Comment {
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

extension CommentEntity: SyncableEntity {
  public static func predicateForModel(_ model: Models.Comment) -> NSPredicate {
    \CommentEntity.commentAttributes.uniqueID == model.commentAttributes.id
  }

  public func populateEntityFrom(_ model: Comment, on storage: any StorageType) throws {
    commentID = model.commentAttributes.id
    commentCounts = try storage.findOrInsert(
      of: CommentCountsEntity.self,
      usingDTO: model.countsData)
    commentAttributes = try storage.findOrInsert(
      of: CommentAttributesEntity.self,
      usingDTO: model.commentAttributes)
    postAttributes = try storage.findOrInsert(
      of: PostAttributesEntity.self,
      usingDTO: model.postData)
    creatorAttributes = try storage.findOrInsert(
      of: PersonAttributesEntity.self,
      usingDTO: model.creator)
    communityAttributes = try storage.findOrInsert(
      of: CommunityAttributesEntity.self,
      usingDTO: model.communityAttributes)
  }

  public func updateEntityFrom(_ model: Models.Comment, on storage: StorageType) throws {
    try commentAttributes.updateEntityFrom(model.commentAttributes, on: storage)
    try creatorAttributes.updateEntityFrom(model.creator, on: storage)
    try postAttributes.updateEntityFrom(model.postData, on: storage)
    try communityAttributes.updateEntityFrom(model.communityAttributes, on: storage)
    try commentCounts.updateEntityFrom(model.countsData, on: storage)
  }
}
