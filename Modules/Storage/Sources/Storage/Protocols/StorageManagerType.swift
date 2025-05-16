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

    func performRead<ResultType>(_ readClosure: @escaping (NSManagedObjectContext) -> ResultType) async -> ResultType

    @discardableResult
    func performWrite<ResultType>(
        _ schedule: NSManagedObjectContext.ScheduledTaskType,
        _ writeClosure: @escaping (NSManagedObjectContext) throws -> ResultType?)
        async throws -> ResultType?

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

    func saveChangesWithClosure() {
        writerDerivedStorage.perform {
            self.writerDerivedStorage.saveIfNeeded()

            self.viewStorage.perform {
                self.viewStorage.saveIfNeeded()
            }
        }
    }

    public func saveChanges() async {
        await writerDerivedStorage.perform {
            self.writerDerivedStorage.saveIfNeeded()
        }
        await viewStorage.perform {
            self.viewStorage.saveIfNeeded()
        }
    }
}
