import CoreData

public typealias EntityType = NSManagedObject & Object & ReadOnlyConvertible & SyncableEntity
public typealias WriteStorageClosure<ResultType> = (StorageType) throws -> ResultType

// MARK: - CoreDataStore + WriteOnlyStore

extension CoreDataStore: WriteOnlyStore {
    public func update<T: EntityType>(_ model: T.ReadOnlyModel, ofType type: T.Type) async throws {
        try await performWrite(.scheduled) { storage in
            guard let firstObject = storage.firstObject(of: type, matching: T.predicateForModel(model)) else {
                return
            }
            try firstObject.updateEntityFrom(model, on: storage)
        }
    }

    public func delete<T: EntityType>(_ model: T.ReadOnlyModel, ofType type: T.Type) async throws {
        try await performWrite(.scheduled) { storage in
            guard let firstObject = storage.firstObject(of: type, matching: T.predicateForModel(model)) else {
                return
            }
            storage.deleteObject(firstObject)
        }
    }

    public func synchronize<T: EntityType>(_ model: T.ReadOnlyModel, ofType type: T.Type) async throws {
        try await performWrite(.scheduled) { storage in
            if let firstObject = storage.firstObject(of: type, matching: T.predicateForModel(model)) {
                try firstObject.updateEntityFrom(model, on: storage)
            } else {
                let newObject = storage.insertNewObject(ofType: type)
                try newObject.populateEntityFrom(model, on: storage)
            }
        }
    }

    public func synchronize<T: EntityType>(_ models: [T.ReadOnlyModel], ofType type: T.Type) async throws {
        try await performWrite(.scheduled) { storage in
            for model in models {
                if let firstObject = storage.firstObject(of: type, matching: T.predicateForModel(model)) {
                    try firstObject.updateEntityFrom(model, on: storage)
                } else {
                    let newObject = storage.insertNewObject(ofType: type)
                    try newObject.populateEntityFrom(model, on: storage)
                }
            }
        }
    }
}
