import CoreData
import Foundation

// MARK: - StorageManagerType

public protocol StorageManagerType {
    /// Returns the `Storage` associated to the main thread
    ///
    var viewStorage: NSManagedObjectContext { get }

    /// Returns a shared derived instance for write operations
    ///
    var writerDerivedStorage: NSManagedObjectContext { get }

    /// Save core data changes
    ///
    func saveChanges() async

    /// Convenience method for clearing the data store
    ///
    func reset()
}

extension StorageManagerType {
    public func performRead<ResultType>(_ readClosure: @escaping (NSManagedObjectContext) -> ResultType) async -> ResultType {
        await viewStorage.perform {
            readClosure(self.viewStorage)
        }
    }

    public func performWrite<ResultType>(
        schedule: NSManagedObjectContext.ScheduledTaskType = .immediate,
        _ writeClosure: @escaping (NSManagedObjectContext) throws -> ResultType)
        async throws -> ResultType
    {
        try await writerDerivedStorage.perform(schedule: schedule) {
            try writeClosure(writerDerivedStorage)
        }
    }
}
