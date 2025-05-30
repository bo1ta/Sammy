import CoreData
import Foundation
import Models
import Principle

// MARK: - CommunityCounts

@objc(CommunityCounts)
public class CommunityCounts: NSManagedObject {

    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<CommunityCounts> {
        NSFetchRequest<CommunityCounts>(entityName: "CommunityCounts")
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
    @NSManaged public var community: Community?
}

// MARK: Identifiable

extension CommunityCounts: Identifiable { }

// MARK: ReadOnlyConvertible

extension CommunityCounts: ReadOnlyConvertible {
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

extension CommunityCounts: SyncableEntity {
    public static func predicateForModel(_ model: Models.CommunityCounts) -> NSPredicate {
        \CommunityCounts.communityID == model.communityID
    }

    public func updateEntityFrom(_ model: Models.CommunityCounts) throws -> Self {
        subscribers = model.subscribers
        posts = model.posts
        comments = model.comments
        usersActiveDay = model.usersActiveDay
        usersActiveWeek = model.usersActiveWeek
        usersActiveHalfYear = model.usersActiveHalfYear
        usersActiveMonth = model.usersActiveMonth
        subscribersLocal = model.subscribersLocal
        return self
    }
}

// MARK: - Models.CommunityCounts + Storable

extension Models.CommunityCounts: Storable {
    public func toEntity(in context: NSManagedObjectContext) throws -> CommunityCounts {
        let entity = CommunityCounts(context: context)
        let modelToEntityMapping = [
            "published": "publishedAt",
        ]
        return CoreDataPopulator.populateFromModel(self, toEntity: entity, nameMapping: modelToEntityMapping)
    }
}
