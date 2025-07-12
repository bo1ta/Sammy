import CoreData

// MARK: - StorageManagerType

public protocol StorageManagerType {
  /// Returns the `Storage` associated to the main thread
  ///
  var viewStorage: NSManagedObjectContext { get }

  /// Returns a shared derived instance for write operations
  ///
  var writerDerivedStorage: NSManagedObjectContext { get }

  /// Performs a read operation asynchronously on the view (main thread) storage context.
  /// - Parameter readClosure: The closure that performs the read operation.
  ///   Takes the view storage context as a parameter and returns the result of the read operation.
  /// - Returns: The result of the read operation.
  ///
  func performRead<ResultType>(_ readClosure: @escaping (NSManagedObjectContext) -> ResultType) async -> ResultType

  /// Performs a write operation asynchronously on the writer storage context.
  /// - Parameters:
  ///   - schedule: Determines when the write operation should be executed.
  ///     See `NSManagedObjectContext.ScheduledTaskType` for options.
  ///   - writeClosure: The closure that performs the write operation.
  ///     Takes the writer storage context as a parameter and returns the result of the write operation or throws an error.
  /// - Returns: The result of the write operation if successful, or nil if the operation failed or returned nil.
  /// - Throws: Any error that occurs during the write operation.
  ///
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

  /// Synchronously saves changes to both writer and view storage contexts.
  /// - Note: This is a synchronous version that performs saves in a blocking manner.
  ///
  func saveChangesWithClosure() {
    writerDerivedStorage.perform {
      self.writerDerivedStorage.saveIfNeeded()

      self.viewStorage.perform {
        self.viewStorage.saveIfNeeded()
      }
    }
  }

  /// Asynchronously saves changes to both writer and view storage contexts.
  ///
  public func saveChanges() async {
    await writerDerivedStorage.perform {
      self.writerDerivedStorage.saveIfNeeded()
    }
    await viewStorage.perform {
      self.viewStorage.saveIfNeeded()
    }
  }
}
