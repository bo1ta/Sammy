import CoreData
import Foundation
import Models
import Principle

// MARK: - SiteAttributesEntity

@objc(SiteAttributesEntity)
public class SiteAttributesEntity: NSManagedObject {
  @nonobjc
  public class func fetchRequest() -> NSFetchRequest<SiteAttributesEntity> {
    NSFetchRequest<SiteAttributesEntity>(entityName: "SiteAttributesEntity")
  }

  @NSManaged public var uniqueID: Int
  @NSManaged public var name: String
  @NSManaged public var sidebar: String?
  @NSManaged public var publishedAt: String
  @NSManaged public var updatedAt: String?
  @NSManaged public var icon: String?
  @NSManaged public var banner: String?
  @NSManaged public var siteDescription: String?
  @NSManaged public var actorID: String
  @NSManaged public var lastRefreshedAt: String
  @NSManaged public var inboxURL: String
  @NSManaged public var contentWarning: String?
  @NSManaged public var publicKey: String
  @NSManaged public var instanceID: Int
}

// MARK: Identifiable

extension SiteAttributesEntity: Identifiable { }

// MARK: ReadOnlyConvertible

extension SiteAttributesEntity: ReadOnlyConvertible {
  public func toReadOnly() -> Models.SiteAttributes {
    Models
      .SiteAttributes(
        id: uniqueID,
        name: name,
        sidebar: sidebar,
        published: publishedAt,
        updated: updatedAt,
        icon: icon,
        banner: banner,
        description: siteDescription,
        actorID: actorID,
        lastRefreshedAt: lastRefreshedAt,
        inboxUrl: inboxURL,
        contentWarning: contentWarning,
        publicKey: publicKey,
        instanceID: instanceID)
  }
}

// MARK: SyncableEntity

extension SiteAttributesEntity: SyncableEntity {
  public static func predicateForModel(_ model: Models.SiteAttributes) -> NSPredicate {
    \SiteAttributesEntity.uniqueID == model.id
  }

  public func updateEntityFrom(_ model: Models.SiteAttributes, on _: StorageType) throws {
    updatedAt = model.updated
    lastRefreshedAt = model.lastRefreshedAt
    inboxURL = model.inboxUrl
    publicKey = model.publicKey
    contentWarning = model.contentWarning
  }

  public func populateEntityFrom(_ model: SiteAttributes, on _: any StorageType) throws {
    let mapping = [
      "id": "uniqueID",
      "published": "publishedAt",
      "description": "siteDescription",
      "updated": "updatedAt",
      "inboxUrl": "inboxURL",
    ]
    CoreDataPopulator.populateFromModel(model, toEntity: self, nameMapping: mapping)
  }
}
