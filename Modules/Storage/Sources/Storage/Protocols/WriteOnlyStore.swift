//
//  WriteOnlyStore.swift
//  Storage
//
//  Created by Alexandru Solomon on 08.06.2025.
//

public protocol WriteOnlyStore {
    /// Perform a write operation. Uses `writerDerivedStorage`
    ///
    /// - Parameter writeClosure: A closure that performs the write operation on the provided `StorageType`.
    /// - Throws: An error if the write operation fails.
    ///
    func performWrite<ResultType>(
        _ saveSchedule: SaveSchedule,
        _ writeClosure: @escaping WriteStorageClosure<ResultType>) async throws -> ResultType

    /// Update an entity in the storage with the given model.
    ///
    /// - Parameters:
    ///   - model: The model containing the updated data.
    ///   - type: The type of the entity to update.
    /// - Throws: An error if the update operation fails.
    ///
    func update<T: EntityType>(_ model: T.ReadOnlyModel, ofType type: T.Type) async throws

    /// Delete an entity from the storage that matches the given model.
    ///
    /// - Parameters:
    ///   - model: The model used to identify the entity to delete.
    ///   - type: The type of the entity to delete.
    /// - Throws: An error if the delete operation fails.
    ///
    func delete<T: EntityType>(_ model: T.ReadOnlyModel, ofType type: T.Type) async throws

    /// Import a single entity into the storage.
    ///
    /// - Parameters:
    ///   - model: The model containing the data to import.
    ///   - type: The type of the entity to import.
    /// - Throws: An error if the import operation fails.
    ///
    func synchronize<T: EntityType>(_ model: T.ReadOnlyModel, ofType type: T.Type) async throws

    /// Import multiple entities into the storage.
    ///
    /// - Parameters:
    ///   - models: An array of models containing the data to import.
    ///   - type: The type of the entities to import.
    /// - Throws: An error if the import operation fails.
    ///
    func synchronize<T: EntityType>(_ models: [T.ReadOnlyModel], ofType type: T.Type) async throws
}
