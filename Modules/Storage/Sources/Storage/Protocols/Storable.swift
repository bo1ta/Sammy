import CoreData
import Foundation

protocol Storable: Identifiable where ID: CVarArg {
    associatedtype Entity: NSManagedObject

    /// Converts the model to a Core Data entity (insert or update).
    ///
    func toEntity(in context: NSManagedObjectContext) throws -> Entity

    /// Create the model from a Core Data entity
    ///
    static func from(_ entity: Entity, in context: NSManagedObjectContext) throws -> Self
}
