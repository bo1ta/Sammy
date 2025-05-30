import CoreData
import Foundation
import Models
import Principle

// MARK: - Community

@objc(Community)
public class Community: NSManagedObject {
    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<Community> {
        NSFetchRequest<Community>(entityName: "Community")
    }

    @NSManaged public var subscribed: String
    @NSManaged public var blocked: Bool
    @NSManaged public var bannedFromCommunity: Bool
    @NSManaged public var communityAttributes: CommunityAttributes
    @NSManaged public var communityCounts: CommunityCounts
    @NSManaged public var personModerates: NSSet?
}

// MARK: Identifiable

extension Community: Identifiable { }

// MARK: ReadOnlyConvertible

extension Community: ReadOnlyConvertible {
    public func toReadOnly() -> Models.Community {
        Models
            .Community(
                attributes: communityAttributes.toReadOnly(),
                subscribed: subscribed,
                blocked: blocked,
                counts: communityCounts.toReadOnly(),
                bannedFromCommunity: bannedFromCommunity)
    }
}

// MARK: SyncableEntity

extension Community: SyncableEntity {
    public static func predicateForModel(_ model: Models.Community) -> NSPredicate {
        \Community.communityAttributes.uniqueID == model.attributes.id
    }

    public func updateEntityFrom(_ model: Models.Community) throws -> Self {
        subscribed = model.subscribed
        blocked = model.blocked
        bannedFromCommunity = model.bannedFromCommunity

        _ = try communityAttributes.updateEntityFrom(model.attributes)
        _ = try communityCounts.updateEntityFrom(model.counts)

        return self
    }
}

// MARK: - Models.Community + Storable

extension Models.Community: Storable {
    public func toEntity(in context: NSManagedObjectContext) throws -> Community {
        let entity = Community(context: context)
        entity.subscribed = subscribed
        entity.blocked = blocked
        entity.bannedFromCommunity = bannedFromCommunity

        entity.communityCounts = try CommunityCounts.findOrInsert(model: counts, on: context)
        entity.communityAttributes = try CommunityAttributes.findOrInsert(model: attributes, on: context)

        return entity
    }
}
