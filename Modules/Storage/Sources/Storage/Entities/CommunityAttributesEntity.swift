import CoreData
import Foundation
import Models
import Principle

// MARK: - CommunityAttributesEntity

@objc(CommunityAttributesEntity)
public class CommunityAttributesEntity: NSManagedObject {
    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<CommunityAttributesEntity> {
        NSFetchRequest<CommunityAttributesEntity>(entityName: "CommunityAttributesEntity")
    }

    @NSManaged public var uniqueID: Int
    @NSManaged public var name: String
    @NSManaged public var title: String
    @NSManaged public var communityDescription: String?
    @NSManaged public var publishedAt: String
    @NSManaged public var updatedAt: String?
    @NSManaged public var icon: String?
    @NSManaged public var banner: String?
    @NSManaged public var visibility: String
    @NSManaged public var community: CommunityEntity?
    @NSManaged public var comments: NSSet?
    @NSManaged public var posts: PostEntity?
}

// MARK: Identifiable

extension CommunityAttributesEntity: Identifiable { }

// MARK: ReadOnlyConvertible

extension CommunityAttributesEntity: ReadOnlyConvertible {
    public func toReadOnly() -> Models.CommunityAttributes {
        Models
            .CommunityAttributes(
                id: uniqueID,
                name: name,
                title: title,
                description: communityDescription,
                published: publishedAt,
                updated: updatedAt,
                icon: icon,
                banner: banner,
                visibility: visibility)
    }
}

// MARK: SyncableEntity

extension CommunityAttributesEntity: SyncableEntity {
    public static func predicateForModel(_ model: Models.CommunityAttributes) -> NSPredicate {
        \CommunityAttributesEntity.uniqueID == model.id
    }

    public func updateEntityFrom(_ model: Models.CommunityAttributes, on _: StorageType) throws {
        name = model.name
        title = model.title
        communityDescription = model.description
        updatedAt = model.updated
        icon = model.icon
        banner = model.banner
        visibility = model.visibility
    }

    public func populateEntityFrom(_ model: CommunityAttributes, on _: any StorageType) throws {
        let modelToEntityMapping: [String: String] = [
            "id": "uniqueID",
            "description": "communityDescription",
            "updated": "updatedAt",
            "published": "publishedAt",
        ]
        CoreDataPopulator.populateFromModel(model, toEntity: self, nameMapping: modelToEntityMapping)
    }
}
