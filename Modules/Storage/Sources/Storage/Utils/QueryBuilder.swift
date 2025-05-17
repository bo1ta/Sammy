import CoreData
import OSLog
import Principle

/// A type-safe, chainable interface for building Core Data queries
///
class QueryBuilder<Entity: NSManagedObject> {
    private let logger = Logger(subsystem: "com.Sammy.Storage", category: "QueryBuilder")

    private let context: NSManagedObjectContext
    private var predicate: NSPredicate?
    private var sortDescriptors: [NSSortDescriptor] = []
    private var limit: Int?

    /// Initializes a new QueryBuilder
    /// - Parameter context: The context to perform operations on
    ///
    init(on context: NSManagedObjectContext) {
        self.context = context
    }

    // MARK: - Execution methods

    /// Executes the query and returns all matching results
    /// - Returns: An array of entities matching the query parameters
    ///
    /// Example:
    /// ```
    /// let allPosts = ManagedPost.query(on: context).all()
    /// ```
    ///
    func all() -> [Entity] {
        let request = Entity.fetchRequest()
        request.predicate = self.predicate
        request.sortDescriptors = self.sortDescriptors

        if let limit = self.limit {
            request.fetchLimit = limit
        }

        do {
            return try self.context.fetch(request) as? [Entity] ?? []
        } catch {
            logger.error("Error fetching \(String(describing: Entity.self)): \(error). Returning an empty array")
            return []
        }
    }

    /// Returns the count of objects matching the current query
    ///
    func count() -> Int {
        let request = Entity.fetchRequest()
        request.predicate = self.predicate
        do {
            return try self.context.count(for: request)
        } catch {
            logger.error("Error getting count \(String(describing: Entity.self)): \(error). Returning 0")
            return 0
        }
    }

    // MARK: - Filtering

    /// Adds an NSPredicate to the query
    /// - Parameter predicate: The predicate to apply
    /// - Returns: The modified query builder for chaining
    ///
    func filter(_ predicate: NSPredicate) -> Self {
        self.predicate = self.predicate.map { NSCompoundPredicate(andPredicateWithSubpredicates: [$0, predicate]) } ?? predicate
        return self
    }

    /// Adds a type-safe predicate to the query
    /// - Parameter predicate: The Principle predicate to apply. Principle predicates allow keypaths operations.
    /// - Returns: The modified query builder for chaining
    ///
    func filter(_ predicate: Principle.Predicate<Entity>) -> Self {
        self.predicate = self.predicate.map { NSCompoundPredicate(andPredicateWithSubpredicates: [$0, predicate]) } ?? predicate
        return self
    }

    /// Adds a sort descriptor to the query
    /// - Parameters:
    ///   - keyPath: The key path to sort by
    ///   - ascending: Whether to sort ascending (default) or descending
    /// - Returns: The modified query builder for chaining
    ///
    func sort<T>(_ keyPath: KeyPath<Entity, T>, ascending: Bool) -> Self {
        let descriptor = NSSortDescriptor(
            key: NSExpression(forKeyPath: keyPath).keyPath,
            ascending: ascending)
        sortDescriptors.append(descriptor)
        return self
    }

    /// Limits the number of results returned
    /// - Parameter count: The maximum number of results to return
    /// - Returns: The modified query builder for chaining
    ///
    func limit(_ count: Int) -> Self {
        self.limit = count
        return self
    }

    /// Returns the first result matching the current query
    /// - Returns: An optional entity instance
    ///
    func first() -> Entity? {
        _ = limit(1)
        return all().first
    }

    /// Returns the first result matching the given predicate
    /// - Parameter predicate: The predicate to filter by
    /// - Returns: An optional entity instance
    ///
    func first(where predicate: Principle.Predicate<Entity>) -> Entity? {
        filter(predicate).first()
    }

    /// Returns the first result matching the given predicate
    /// - Parameter predicate: The predicate to filter by
    /// - Returns: An optional entity instance
    ///
    func first(where predicate: NSPredicate) -> Entity? {
        filter(predicate).first()
    }
}
