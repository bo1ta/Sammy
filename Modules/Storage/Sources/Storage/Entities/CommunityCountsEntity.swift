import CoreData
import Foundation
import Models
import Principle

// MARK: - CommunityCountsEntity

@objc(CommunityCountsEntity)
public class CommunityCountsEntity: NSManagedObject {

  @nonobjc
  public class func fetchRequest() -> NSFetchRequest<CommunityCountsEntity> {
    NSFetchRequest<CommunityCountsEntity>(entityName: "CommunityCountsEntity")
  }

  @NSManaged public var communityID: Int
  @NSManaged public var subscribers: Int
  @NSManaged public var posts: Int
  @NSManaged public var comments: Int
  @NSManaged public var publishedAt: String
  @NSManaged public var usersActiveDay: Int
  @NSManaged public var usersActiveWeek: Int
  @NSManaged public var usersActiveHalfYear: Int
  @NSManaged public var usersActiveMonth: Int
  @NSManaged public var subscribersLocal: Int
  @NSManaged public var community: CommunityEntity?
}

// MARK: Identifiable

extension CommunityCountsEntity: Identifiable { }

// MARK: ReadOnlyConvertible

extension CommunityCountsEntity: ReadOnlyConvertible {
  public func toReadOnly() -> Models.CommunityCounts {
    Models.CommunityCounts(
      communityID: communityID,
      subscribers: subscribers,
      posts: posts,
      comments: comments,
      published: publishedAt,
      usersActiveDay: usersActiveDay,
      usersActiveWeek: usersActiveWeek,
      usersActiveMonth: usersActiveMonth,
      usersActiveHalfYear: usersActiveHalfYear,
      subscribersLocal: subscribersLocal)
  }
}

// MARK: SyncableEntity

extension CommunityCountsEntity: SyncableEntity {
  public static func predicateForModel(_ model: Models.CommunityCounts) -> NSPredicate {
    \CommunityCountsEntity.communityID == model.communityID
  }

  public func updateEntityFrom(_ model: Models.CommunityCounts, on _: any StorageType) throws {
    subscribers = model.subscribers
    posts = model.posts
    comments = model.comments
    usersActiveDay = model.usersActiveDay
    usersActiveWeek = model.usersActiveWeek
    usersActiveHalfYear = model.usersActiveHalfYear
    usersActiveMonth = model.usersActiveMonth
    subscribersLocal = model.subscribersLocal
  }

  public func populateEntityFrom(_ model: CommunityCounts, on _: any StorageType) throws {
    let modelToEntityMapping = [
      "published": "publishedAt",
    ]
    CoreDataPopulator.populateFromModel(model, toEntity: self, nameMapping: modelToEntityMapping)
  }
}
