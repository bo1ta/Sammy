import CoreData

extension NSManagedObjectContext {
    public static var expirationDeadline: ExpirationDeadline {
        .oneHour
    }

    func saveIfNeeded() {
        guard hasChanges else {
            return
        }

        do {
            try save()
        } catch {
            rollback()
        }
    }
}

// MARK: - NSManagedObject + Object

extension NSManagedObject: Object {

    /// Returns the Entity Name, if available, as specified in the NSEntityDescription. Otherwise, will return
    /// the subclass name.
    ///
    public class var entityName: String {
        guard let name = NSStringFromClass(self).components(separatedBy: ".").last else {
            fatalError("Invalid entity name")
        }

        return name
    }
}
