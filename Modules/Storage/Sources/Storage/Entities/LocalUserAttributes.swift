import CoreData
import Foundation
import Models
import Principle

// MARK: - LocalUserAttributes

@objc(LocalUserAttributes)
public class LocalUserAttributes: NSManagedObject {
    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<LocalUserAttributes> {
        NSFetchRequest<LocalUserAttributes>(entityName: "LocalUserAttributes")
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
    @NSManaged public var localUser: LocalUser?
}

// MARK: Identifiable

extension LocalUserAttributes: Identifiable { }

// MARK: ReadOnlyConvertible

extension LocalUserAttributes: ReadOnlyConvertible {
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

extension LocalUserAttributes: SyncableEntity {
    public static func predicateForModel(_ model: Models.LocalUserAttributes) -> NSPredicate {
        \LocalUserAttributes.uniqueID == model.id
    }

    public func updateEntityFrom(_ model: Models.LocalUserAttributes) throws -> Self {
        showNSFW = model.showNSFW
        showAvatars = model.showAvatars
        interfaceLanguage = model.interfaceLanguage
        defaultSortType = model.defaultSortType.rawValue
        defaultListingType = model.defaultListingType.rawValue
        return self
    }
}

// MARK: - Models.LocalUserAttributes + Storable

extension Models.LocalUserAttributes: Storable {
    public func toEntity(in context: NSManagedObjectContext) throws -> LocalUserAttributes {
        let entity = LocalUserAttributes(context: context)
        entity.defaultSortType = defaultSortType.rawValue
        entity.defaultListingType = defaultListingType.rawValue
        entity.uniqueID = id
        return CoreDataPopulator.populateFromModel(self, toEntity: entity, nameMapping: [:])
    }
}
