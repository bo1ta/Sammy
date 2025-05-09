import CoreData

// MARK: - QueryProvider

/// A protocol that enables type-safe Core Data query building for NSManagedObject subclasses
/// Conforming types gain access to the `query(on:)` static method
///
protocol QueryProvider { }

extension QueryProvider where Self: NSManagedObject {

    /// Creates a new QueryBuilder for the current entity type
    /// - Parameter context: The NSManagedObjectContext to perform operations on
    /// - Returns: A configured QueryBuilder instance
    ///
    /// Example:
    /// ```
    /// let personQuery = Person.query(on: context)
    /// let persons = query.first(where: \.name == "John Doe)
    /// ```
    static func query(on context: NSManagedObjectContext) -> QueryBuilder<Self> {
        QueryBuilder(on: context)
    }
}

// MARK: - NSManagedObject + QueryProvider

extension NSManagedObject: QueryProvider { }
