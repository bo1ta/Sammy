import CoreData
import Foundation
import Models
import Principle

// MARK: - CommunityAttributes

@objc(CommunityAttributes)
public class CommunityAttributes: NSManagedObject {
    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<CommunityAttributes> {
        NSFetchRequest<CommunityAttributes>(entityName: "CommunityAttributes")
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
    @NSManaged public var community: Community?
    @NSManaged public var comments: NSSet?
    @NSManaged public var posts: Post?
}

// MARK: Identifiable

extension CommunityAttributes: Identifiable { }

// MARK: ReadOnlyConvertible

extension CommunityAttributes: ReadOnlyConvertible {
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

extension CommunityAttributes: SyncableEntity {
    public static func predicateForModel(_ model: Models.CommunityAttributes) -> NSPredicate {
        \CommentAttributes.uniqueID == model.id
    }

    public func updateEntityFrom(_ model: Models.CommunityAttributes) throws -> Self {
        name = model.name
        title = model.title
        communityDescription = model.description
        updatedAt = model.updated
        icon = model.icon
        banner = model.banner
        visibility = model.visibility
        return self
    }
}

// MARK: - Models.CommunityAttributes + Storable

extension Models.CommunityAttributes: Storable {
    public func toEntity(in context: NSManagedObjectContext) throws -> CommunityAttributes {
        let entity = CommunityAttributes(context: context)
        let modelToEntityMapping: [String: String] = [
            "id": "uniqueID",
            "description": "communityDescription",
            "updated": "updatedAt",
            "published": "publishedAt",
        ]
        return CoreDataPopulator.populateFromModel(self, toEntity: entity, nameMapping: modelToEntityMapping)
    }
}
