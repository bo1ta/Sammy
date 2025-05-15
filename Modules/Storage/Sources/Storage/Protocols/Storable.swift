import CoreData
import Foundation

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
    @discardableResult func toEntity(in context: NSManagedObjectContext) throws -> Entity
}
