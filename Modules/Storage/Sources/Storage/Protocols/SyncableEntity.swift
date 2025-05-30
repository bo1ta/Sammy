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

// MARK: - CoreDataSyncError

enum CoreDataSyncError: Error {
    case invalidContext
}

extension NSManagedObject {
    func updateToManyRelationship<Model: Storable, Entity: SyncableEntity>(
        models: some Sequence<Model>,
        currentEntities: Set<Entity>,
        compare: @escaping (Model, Entity) -> Bool,
        add: @escaping (Set<Entity>) -> Void,
        remove: @escaping (Set<Entity>) -> Void)
        throws where Model.Entity == Entity, Entity.ReadOnlyModel == Model
    {
        guard let context = managedObjectContext else {
            throw CoreDataSyncError.invalidContext
        }

        /// Remove entities not present in models
        let entitiesToRemove = currentEntities.filter { entity in
            !models.contains { model in compare(model, entity) }
        }
        if !entitiesToRemove.isEmpty {
            remove(entitiesToRemove)
        }

        /// Update existing or insert new
        var entitiesToAdd: Set<Entity> = []
        try models.forEach { model in
            if let existing = currentEntities.first(where: { compare(model, $0) }) {
                try existing.updateEntityFrom(model)
            } else {
                let newEntity = try Entity.findOrInsert(model: model, on: context)
                entitiesToAdd.insert(newEntity)
            }
        }

        /// Add new entities
        if !entitiesToAdd.isEmpty {
            add(entitiesToAdd)
        }
    }
}
