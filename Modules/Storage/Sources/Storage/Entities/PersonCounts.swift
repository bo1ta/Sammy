import CoreData
import Foundation
import Models
import Principle

// MARK: - PersonCounts

@objc(PersonCounts)
public class PersonCounts: NSManagedObject {
    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<PersonCounts> {
        NSFetchRequest<PersonCounts>(entityName: "PersonCounts")
    }

    @NSManaged public var personID: Int
    @NSManaged public var postCount: Int
    @NSManaged public var commentCount: Int
    @NSManaged public var personProfile: PersonProfile?
}

// MARK: Identifiable

extension PersonCounts: Identifiable { }

// MARK: ReadOnlyConvertible

extension PersonCounts: ReadOnlyConvertible {
    public func toReadOnly() -> Models.PersonCounts {
        Models.PersonCounts(personID: personID, postCount: postCount, commentCount: commentCount)
    }
}

// MARK: SyncableEntity

extension PersonCounts: SyncableEntity {
    public static func predicateForModel(_ model: Models.PersonCounts) -> NSPredicate {
        \PersonCounts.personID == model.personID
    }

    public func updateEntityFrom(_ model: Models.PersonCounts) throws -> Self {
        postCount = model.postCount
        commentCount = model.commentCount
        return self
    }
}

// MARK: - Models.PersonCounts + Storable

extension Models.PersonCounts: Storable {
    public func toEntity(in context: NSManagedObjectContext) throws -> PersonCounts {
        let entity = PersonCounts(context: context)
        return CoreDataPopulator.populateFromModel(self, toEntity: entity, nameMapping: [:])
    }
}
