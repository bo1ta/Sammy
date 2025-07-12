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

  @NSManaged public var unreadComments: NSNumber
  @NSManaged public var isHidden: Bool
  @NSManaged public var isRead: Bool
  @NSManaged public var isSaved: Bool
  @NSManaged public var myVote: NSNumber
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
      communityAttributes: communityAttributes.toReadOnly(),
      saved: isSaved,
      read: isRead,
      hidden: isHidden,
      myVote: myVote.intValue,
      unreadComments: unreadComments.intValue)
  }
}

// MARK: SyncableEntity

extension PostEntity: SyncableEntity {
  public static func predicateForModel(_ model: Models.Post) -> NSPredicate {
    \PostEntity.postAttributes.uniqueID == model.attributes.id
  }

  public func updateEntityFrom(_ model: Models.Post, on storage: StorageType) throws {
    isHidden = model.hidden
    isSaved = model.saved
    isRead = model.read
    unreadComments = model.unreadComments as NSNumber
    myVote = model.voteType.rawValue as NSNumber

    try postAttributes.updateEntityFrom(model.attributes, on: storage)
    try creatorAttributes.updateEntityFrom(model.creator, on: storage)
    try postCounts.updateEntityFrom(model.postCounts, on: storage)
    try communityAttributes.updateEntityFrom(model.communityAttributes, on: storage)
  }

  public func populateEntityFrom(_ model: Post, on storage: any StorageType) throws {
    isHidden = model.hidden
    isSaved = model.saved
    isRead = model.read
    unreadComments = model.unreadComments as NSNumber
    myVote = model.voteType.rawValue as NSNumber

    postAttributes = try storage.findOrInsert(
      of: PostAttributesEntity.self,
      usingDTO: model.attributes)
    creatorAttributes = try storage.findOrInsert(
      of: PersonAttributesEntity.self,
      usingDTO: model.creator)
    postCounts = try storage.findOrInsert(
      of: PostCountsEntity.self,
      usingDTO: model.postCounts)
    communityAttributes = try storage.findOrInsert(
      of: CommunityAttributesEntity.self,
      usingDTO: model.communityAttributes)
  }
}
