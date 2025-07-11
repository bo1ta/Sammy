import CoreData
import Foundation
import Models
import Principle

// MARK: - CommunityEntity

@objc(CommunityEntity)
public class CommunityEntity: NSManagedObject {
    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<CommunityEntity> {
        NSFetchRequest<CommunityEntity>(entityName: "CommunityEntity")
    }

    @NSManaged public var subscribed: String
    @NSManaged public var blocked: Bool
    @NSManaged public var bannedFromCommunity: Bool
    @NSManaged public var communityAttributes: CommunityAttributesEntity
    @NSManaged public var communityCounts: CommunityCountsEntity
    @NSManaged public var personModerates: NSSet?
}

// MARK: Identifiable

extension CommunityEntity: Identifiable { }

// MARK: ReadOnlyConvertible

extension CommunityEntity: ReadOnlyConvertible {
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

extension CommunityEntity: SyncableEntity {
    public static func predicateForModel(_ model: Models.Community) -> NSPredicate {
        \CommunityEntity.communityAttributes.uniqueID == model.attributes.id
    }

    public func updateEntityFrom(_ model: Models.Community, on storage: any StorageType) throws {
        subscribed = model.subscribed
        blocked = model.blocked
        bannedFromCommunity = model.bannedFromCommunity

        _ = try communityAttributes.updateEntityFrom(model.attributes, on: storage)
        _ = try communityCounts.updateEntityFrom(model.counts, on: storage)
    }

    public func populateEntityFrom(_ model: Community, on storage: any StorageType) throws {
        self.subscribed = subscribed
        self.blocked = blocked
        self.bannedFromCommunity = bannedFromCommunity
        self.communityCounts = try storage.findOrInsert(
            of: CommunityCountsEntity.self,
            usingDTO: model.counts)
        self.communityAttributes = try storage.findOrInsert(
            of: CommunityAttributesEntity.self,
            usingDTO: model.attributes)
    }
}
