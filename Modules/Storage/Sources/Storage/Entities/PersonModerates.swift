import CoreData
import Foundation
import Models
import Principle

// MARK: - PersonModerates

@objc(PersonModerates)
public class PersonModerates: NSManagedObject {
    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<PersonModerates> {
        NSFetchRequest<PersonModerates>(entityName: "PersonModerates")
    }

    @NSManaged public var personID: Int
    @NSManaged public var communities: Set<Community>
    @NSManaged public var moderator: PersonAttributes
}

// MARK: Generated accessors for communities
extension PersonModerates {

    @objc(addCommunitiesObject:)
    @NSManaged
    public func addToCommunities(_ value: Community)

    @objc(removeCommunitiesObject:)
    @NSManaged
    public func removeFromCommunities(_ value: Community)

    @objc(addCommunities:)
    @NSManaged
    public func addToCommunities(_ values: NSSet)

    @objc(removeCommunities:)
    @NSManaged
    public func removeFromCommunities(_ values: NSSet)

}

// MARK: Identifiable

extension PersonModerates: Identifiable { }

// MARK: ReadOnlyConvertible

extension PersonModerates: ReadOnlyConvertible {
    public func toReadOnly() -> Models.PersonDetails.Moderates {
        Models.PersonDetails.Moderates(communities: communities.map { $0.toReadOnly() }, moderator: moderator.toReadOnly())
    }
}

// MARK: SyncableEntity

extension PersonModerates: SyncableEntity {
    public static func predicateForModel(_ model: Models.PersonDetails.Moderates) -> NSPredicate {
        \PersonModerates.personID == model.moderator.id
    }

    public func updateEntityFrom(_: Models.PersonDetails.Moderates) throws -> Self {
        self
    }
}

// MARK: - Models.PersonDetails.Moderates + Storable

extension Models.PersonDetails.Moderates: Storable {
    public func toEntity(in context: NSManagedObjectContext) throws -> PersonModerates {
        let entity = PersonModerates(context: context)
        entity.personID = moderator.id
        entity.moderator = try PersonAttributes.findOrInsert(model: moderator, on: context)

        for community in communities {
            let communityEntity = try Community.findOrInsert(model: community, on: context)
            entity.addToCommunities(communityEntity)
        }

        return entity
    }
}
