import CoreData
import Factory
import Foundation

// MARK: - Storable

/// Provides bidirectional conversion between models and Core Data entities
///
public protocol Storable {
    /// The associated Core Data entity type
    associatedtype Entity: NSManagedObject

    /// Converts the model to a Core Data entity
    /// - Parameter context: The context to create the entity in
    /// - Returns: The configured entity instance
    /// - Throws: Any conversion errors
    ///
    /// Example:
    /// ```
    /// let post = Post(title: "Hello")
    /// let entity = try post.toEntity(in: context)
    /// ```
    ///
    @discardableResult
    func toEntity(in context: NSManagedObjectContext) throws -> Entity
}

/// Helper for tests
///
extension Storable {
    func persisting() async throws -> Self {
        try await Container.shared.storageManager().performWrite(.immediate) { context in
            try self.toEntity(in: context)
        }
        return self
    }
}
