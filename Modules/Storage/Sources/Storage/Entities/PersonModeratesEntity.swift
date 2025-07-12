import CoreData
import Foundation
import Models
import Principle

// MARK: - PersonModeratesEntity

@objc(PersonModeratesEntity)
public class PersonModeratesEntity: NSManagedObject {
  @nonobjc
  public class func fetchRequest() -> NSFetchRequest<PersonModeratesEntity> {
    NSFetchRequest<PersonModeratesEntity>(entityName: "PersonModerates")
  }

  @NSManaged public var personID: Int
  @NSManaged public var communities: Set<CommunityEntity>
  @NSManaged public var moderator: PersonAttributesEntity
}

// MARK: Generated accessors for communities
extension PersonModeratesEntity {

  @objc(addCommunitiesObject:)
  @NSManaged
  public func addToCommunities(_ value: CommunityEntity)

  @objc(removeCommunitiesObject:)
  @NSManaged
  public func removeFromCommunities(_ value: CommunityEntity)

  @objc(addCommunities:)
  @NSManaged
  public func addToCommunities(_ values: NSSet)

  @objc(removeCommunities:)
  @NSManaged
  public func removeFromCommunities(_ values: NSSet)

}

// MARK: Identifiable

extension PersonModeratesEntity: Identifiable { }

// MARK: ReadOnlyConvertible

extension PersonModeratesEntity: ReadOnlyConvertible {
  public func toReadOnly() -> Models.PersonDetails.Moderates {
    Models.PersonDetails.Moderates(communities: communities.map { $0.toReadOnly() }, moderator: moderator.toReadOnly())
  }
}

// MARK: SyncableEntity

extension PersonModeratesEntity: SyncableEntity {
  public static func predicateForModel(_ model: Models.PersonDetails.Moderates) -> NSPredicate {
    \PersonModeratesEntity.personID == model.moderator.id
  }

  public func updateEntityFrom(_: Models.PersonDetails.Moderates, on _: StorageType) throws { }

  public func populateEntityFrom(_ model: PersonDetails.Moderates, on storage: any StorageType) throws {
    self.personID = model.moderator.id
    self.moderator = storage.findOrInsert(
      of: PersonAttributesEntity.self,
      using: PersonAttributesEntity.predicateForModel(model.moderator))

    for community in model.communities {
      let communityEntity = storage.findOrInsert(
        of: CommunityEntity.self,
        using: CommunityEntity.predicateForModel(community))
      self.addToCommunities(communityEntity)
    }
  }
}
