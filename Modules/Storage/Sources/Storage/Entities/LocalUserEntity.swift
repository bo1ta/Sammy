import CoreData
import Foundation
import Models
import Principle

// MARK: - LocalUserEntity

@objc(LocalUserEntity)
public class LocalUserEntity: NSManagedObject {

  @nonobjc
  public class func fetchRequest() -> NSFetchRequest<LocalUserEntity> {
    NSFetchRequest<LocalUserEntity>(entityName: "LocalUserEntity")
  }

  @NSManaged public var localUserAttributes: LocalUserAttributesEntity
  @NSManaged public var personAttributes: PersonAttributesEntity
}

// MARK: Identifiable

extension LocalUserEntity: Identifiable { }

// MARK: ReadOnlyConvertible

extension LocalUserEntity: ReadOnlyConvertible {
  public func toReadOnly() -> Models.LocalUser {
    Models.LocalUser(userAttributes: localUserAttributes.toReadOnly(), personAttributes: personAttributes.toReadOnly())
  }
}

// MARK: SyncableEntity

extension LocalUserEntity: SyncableEntity {
  public static func predicateForModel(_ model: Models.LocalUser) -> NSPredicate {
    \LocalUserEntity.localUserAttributes.uniqueID == model.userAttributes.id && \LocalUserEntity.personAttributes
      .uniqueID == model
      .personAttributes.id
  }

  public func updateEntityFrom(_ model: Models.LocalUser, on storage: StorageType) throws {
    try localUserAttributes.updateEntityFrom(model.userAttributes, on: storage)
    try personAttributes.updateEntityFrom(model.personAttributes, on: storage)
  }

  public func populateEntityFrom(_ model: LocalUser, on storage: any StorageType) throws {
    localUserAttributes = try storage.findOrInsert(
      of: LocalUserAttributesEntity.self,
      usingDTO: model.userAttributes)
    personAttributes = try storage.findOrInsert(
      of: PersonAttributesEntity.self,
      usingDTO: model.personAttributes)
  }
}
