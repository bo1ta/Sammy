import CoreData
import Principle

public typealias ReadStorageClosure<ResultType> = (StorageType) -> ResultType

// MARK: - ReadOnlyStore

public protocol ReadOnlyStore: Sendable {
    /// Perform a read operation. Uses `viewStorage`
    ///
    /// - Parameter readClosure: A closure that performs the read operation on the provided `StorageType`.
    /// - Returns: The result of the read operation.
    ///
    func performRead<ResultType>(_ readClosure: @escaping ReadStorageClosure<ResultType>) async -> ResultType

    /// Perform a blocking read operation. Uses `viewStorage`
    ///
    /// - Parameter readClosure: A closure that performs the read operation on the provided `StorageType`.
    /// - Returns: The result of the read operation.
    ///
    func performBlockingRead<ResultType>(_ readClosure: @escaping ReadStorageClosure<ResultType>) -> ResultType

    /// Get the count of entities of the given type that match the optional predicate.
    ///
    /// - Parameters:
    ///   - type: The type of the entity to count.
    ///   - predicate: An optional `NSPredicate` to filter the entities.
    /// - Returns: The count of matching entities.
    ///
    func objectCount<T: EntityType>(ofType type: T.Type, predicate: NSPredicate?) async -> Int

    /// Get all entities of the given type that match the optional predicate.
    ///
    /// - Parameters:
    ///   - type: The type of the entity to fetch.
    ///   - predicate: An optional `NSPredicate` to filter the entities.
    /// - Returns: An array of read-only entities that match the criteria.
    ///
    func allObjects<T: EntityType>(
        ofType type: T.Type,
        predicate: Principle.Predicate<T>?,
        sortedBy descriptors: [NSSortDescriptor]?) async
        -> [T.ReadOnlyType]

    /// Get all entities of the given type that match the optional predicate, with a fetch limit.
    ///
    /// - Parameters:
    ///   - type: The type of the entity to fetch.
    ///   - fetchLimit: The maximum number of entities to fetch.
    ///   - predicate: An optional `NSPredicate` to filter the entities.
    /// - Returns: An array of read-only entities that match the criteria, limited by the fetch limit.
    ///
    func allObjects<T: EntityType>(
        ofType type: T.Type,
        fetchLimit: Int,
        predicate: Principle.Predicate<T>?,
        sortedBy descriptors: [NSSortDescriptor]?) async -> [T.ReadOnlyType]

    /// Get the first entity of the given type that matches the optional predicate.
    ///
    /// - Parameters:
    ///   - type: The type of the entity to fetch.
    ///   - predicate: An optional `NSPredicate` to filter the entities.
    /// - Returns: The first matching entity, or `nil` if no match is found.
    ///
    func firstObject<T: EntityType>(ofType type: T.Type, predicate: Principle.Predicate<T>?) async -> T.ReadOnlyType?

    /// Get the first random object of a given type, matching the optional predicate.
    /// Internally, it fetches all entities by the unique property, then pulls a `randomElement()` from the array.
    /// Using that random unique value, it returns the random entity.
    ///
    /// - Parameters:
    ///   - type: The type of the entity to fetch.
    ///   - property: The unique property of the entity.
    ///   - predicate: An optional `Predicate` to filter the entities
    /// - Returns: The first random matching entity, or `nil` if no match is found.
    ///
    func firstRandomObject<T: EntityType>(
        ofType type: T.Type,
        byUniqueProperty property: String,
        predicate: Principle.Predicate<T>?) async
        -> T.ReadOnlyType?

    /// Create an `AsyncEntityListener` for the given entity type that matches the specified predicate.
    ///
    /// - Parameters:
    ///   - predicate: The `NSPredicate` used to filter the entities.
    /// - Returns: An `AsyncEntityListener` that streams updates.
    ///
    func entityListener<T: EntityType>(ofType type: T.Type, matching predicate: Principle.Predicate<T>) -> AsyncEntityListener<T>

    /// Creates a `NSFetchedResultsController` for the given entity type that matches predicate, sort descriptors, fetchLimit, etc.
    ///
    ///
    func createFetchedResultsController<T: EntityType>(
        forType type: T.Type,
        matching predicate: Principle.Predicate<T>?,
        sortDescriptors: [NSSortDescriptor],
        fetchLimit: Int?,
        sectionNameKeyPath: String?,
        cacheName: String?) -> NSFetchedResultsController<NSFetchRequestResult>
}
