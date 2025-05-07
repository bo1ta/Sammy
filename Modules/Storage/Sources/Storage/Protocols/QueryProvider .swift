import CoreData

// MARK: - QueryProvider

protocol QueryProvider { }

extension QueryProvider where Self: NSManagedObject {
    static func query(on context: NSManagedObjectContext) -> QueryBuilder<Self> {
        QueryBuilder(on: context)
    }
}

// MARK: - NSManagedObject + QueryProvider

extension NSManagedObject: QueryProvider { }
