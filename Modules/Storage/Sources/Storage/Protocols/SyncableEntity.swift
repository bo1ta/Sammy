import CoreData
import Foundation
import Principle

// MARK: - SyncableEntity

public protocol SyncableEntity {
    associatedtype ReadOnlyModel: Storable

    static func predicateForModel(_ model: ReadOnlyModel) -> NSPredicate
    @discardableResult
    func updateEntityFrom(_ model: ReadOnlyModel) throws -> ReadOnlyModel.Entity
}

extension SyncableEntity where Self: NSManagedObject {
    static func findOrInsert(model: ReadOnlyModel, on context: NSManagedObjectContext) throws -> ReadOnlyModel.Entity {
        if
            let existingEntity = Self.query(on: context)
                .first(where: predicateForModel(model))
        {
            try existingEntity.updateEntityFrom(model)
        } else {
            try model.toEntity(in: context)
        }
    }
}
