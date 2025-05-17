import CoreData
import Foundation
import Models
import Principle

// MARK: - SiteAttributes

@objc(SiteAttributes)
public class SiteAttributes: NSManagedObject {
    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<SiteAttributes> {
        NSFetchRequest<SiteAttributes>(entityName: "SiteAttributes")
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

extension SiteAttributes: Identifiable { }

// MARK: ReadOnlyConvertible

extension SiteAttributes: ReadOnlyConvertible {
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

extension SiteAttributes: SyncableEntity {
    public static func predicateForModel(_ model: Models.SiteAttributes) -> NSPredicate {
        \SiteAttributes.uniqueID == model.id
    }

    public func updateEntityFrom(_ model: Models.SiteAttributes) throws -> Self {
        updatedAt = model.updated
        lastRefreshedAt = model.lastRefreshedAt
        inboxURL = model.inboxUrl
        publicKey = model.publicKey
        contentWarning = model.contentWarning
        return self
    }
}

// MARK: - Models.SiteAttributes + Storable

extension Models.SiteAttributes: Storable {
    public func toEntity(in context: NSManagedObjectContext) throws -> SiteAttributes {
        let entity = SiteAttributes(context: context)
        let mapping = [
            "id": "uniqueID",
            "published": "publishedAt",
            "description": "siteDescription",
            "updated": "updatedAt",
            "inboxUrl": "inboxURL",
        ]
        return CoreDataPopulator.populateFromModel(self, toEntity: entity, nameMapping: mapping)
    }
}
