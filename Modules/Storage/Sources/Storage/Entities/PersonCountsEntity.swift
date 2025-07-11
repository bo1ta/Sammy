import CoreData
import Foundation
import Models
import Principle

// MARK: - PersonCountsEntity

@objc(PersonCountsEntity)
public class PersonCountsEntity: NSManagedObject {
    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<PersonCountsEntity> {
        NSFetchRequest<PersonCountsEntity>(entityName: "PersonCountsEntity")
    }

    @NSManaged public var personID: Int
    @NSManaged public var postCount: Int
    @NSManaged public var commentCount: Int
    @NSManaged public var personProfile: PersonProfileEntity?
}

// MARK: Identifiable

extension PersonCountsEntity: Identifiable { }

// MARK: ReadOnlyConvertible

extension PersonCountsEntity: ReadOnlyConvertible {
    public func toReadOnly() -> Models.PersonCounts {
        Models.PersonCounts(personID: personID, postCount: postCount, commentCount: commentCount)
    }
}

// MARK: SyncableEntity

extension PersonCountsEntity: SyncableEntity {
    public static func predicateForModel(_ model: Models.PersonCounts) -> NSPredicate {
        \PersonCountsEntity.personID == model.personID
    }

    public func updateEntityFrom(_ model: Models.PersonCounts, on _: StorageType) throws {
        postCount = model.postCount
        commentCount = model.commentCount
    }

    public func populateEntityFrom(_ model: PersonCounts, on _: any StorageType) throws {
        CoreDataPopulator.populateFromModel(model, toEntity: self, nameMapping: [:])
    }
}
