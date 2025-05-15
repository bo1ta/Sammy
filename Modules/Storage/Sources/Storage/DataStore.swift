import CoreData
import Factory
import Models
import OSLog
import Principle

public typealias ManagedEntityType = NSManagedObject & ReadOnlyConvertible

public struct DataStore<Entity: ManagedEntityType> {
    @Injected(\.storageManager) private var storageManager: StorageManagerType

    public init() { }

    public func getAll(matching predicate: Principle.Predicate<Entity>? = nil) async -> [Entity.ReadOnlyType] {
        await storageManager.performRead { context in
            Entity.query(on: context)
                .all()
                .map { $0.toReadOnly() }
        }
    }

    public func first(where predicate: Principle.Predicate<Entity>) async -> Entity.ReadOnlyType? {
        await storageManager.performRead { context in
            Entity.query(on: context)
                .first(where: predicate)?
                .toReadOnly()
        }
    }

    public func first() async -> Entity.ReadOnlyType? {
        await storageManager.performRead { context in
            Entity.query(on: context)
                .first()?
                .toReadOnly()
        }
    }

    @discardableResult
    public func updateField<V>(matching predicate: Principle.Predicate<Entity>, keyPath: WritableKeyPath<Entity, V>, to value: V) async throws -> Entity.ReadOnlyType? {
        try await storageManager.performWrite(.immediate) { context in
            guard let entity = Entity.query(on: context).first(where: predicate) else {
                return nil
            }

            let keyPath = NSExpression(forKeyPath: keyPath).keyPath
            entity.setValue(value, forKey: keyPath)
            return entity.toReadOnly()
        }
    }
}

extension DataStore where Entity: SyncableEntity {
    public func importModel(_ model: Entity.ReadOnlyModel) async throws {
        try await storageManager.performWrite(.immediate) { context in
        guard let predicate = Entity.predicateForModel(model) as? Principle.Predicate<Entity> else {
            return
        }

        if let existingEntity = Entity.query(on: context).first(where: predicate) {
            try existingEntity.updateEntityFrom(model)
        } else {
            try model.toEntity(in: context)
        }
    }
  }

    public func importModels(_ models: [Entity.ReadOnlyModel]) async throws where Entity: SyncableEntity {
        try await storageManager.performWrite(.enqueued) { context in
            for model in models {
                guard let predicate = Entity.predicateForModel(model) as? Principle.Predicate<Entity> else {
                    return
                }

                if let existingEntity = Entity.query(on: context).first(where: predicate) {
                   try existingEntity.updateEntityFrom(model)
                } else {
                    try model.toEntity(in: context)
                }
            }
        }
    }
}
