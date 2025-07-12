import CoreData
import Foundation
import Models
import Principle

// MARK: - LocalUserAttributesEntity

@objc(LocalUserAttributesEntity)
public class LocalUserAttributesEntity: NSManagedObject {
  @nonobjc
  public class func fetchRequest() -> NSFetchRequest<LocalUserAttributesEntity> {
    NSFetchRequest<LocalUserAttributesEntity>(entityName: "LocalUserAttributesEntity")
  }

  @NSManaged public var uniqueID: Int
  @NSManaged public var personID: Int
  @NSManaged public var email: String?
  @NSManaged public var showNSFW: Bool
  @NSManaged public var theme: String
  @NSManaged public var defaultSortType: String
  @NSManaged public var defaultListingType: String
  @NSManaged public var interfaceLanguage: String
  @NSManaged public var showAvatars: Bool
  @NSManaged public var localUser: LocalUserEntity?
}

// MARK: Identifiable

extension LocalUserAttributesEntity: Identifiable { }

// MARK: ReadOnlyConvertible

extension LocalUserAttributesEntity: ReadOnlyConvertible {
  public func toReadOnly() -> Models.LocalUserAttributes {
    Models
      .LocalUserAttributes(
        id: uniqueID,
        personID: personID,
        email: email,
        showNSFW: showNSFW,
        theme: theme,
        defaultSortType: .init(rawValue: defaultSortType) ?? .hot,
        defaultListingType: .init(rawValue: defaultListingType) ?? .all,
        interfaceLanguage: interfaceLanguage,
        showAvatars: showAvatars)
  }
}

// MARK: SyncableEntity

extension LocalUserAttributesEntity: SyncableEntity {
  public static func predicateForModel(_ model: Models.LocalUserAttributes) -> NSPredicate {
    \LocalUserAttributesEntity.uniqueID == model.id
  }

  public func updateEntityFrom(_ model: Models.LocalUserAttributes, on _: StorageType) throws {
    showNSFW = model.showNSFW
    showAvatars = model.showAvatars
    interfaceLanguage = model.interfaceLanguage
    defaultSortType = model.defaultSortType.rawValue
    defaultListingType = model.defaultListingType.rawValue
  }

  public func populateEntityFrom(_ model: LocalUserAttributes, on _: any StorageType) throws {
    self.defaultSortType = model.defaultSortType.rawValue
    self.defaultListingType = model.defaultListingType.rawValue
    self.uniqueID = model.id
    CoreDataPopulator.populateFromModel(model, toEntity: self, nameMapping: [:])
  }
}
