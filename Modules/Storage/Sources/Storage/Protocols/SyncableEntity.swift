import CoreData
import Foundation
import Principle

// MARK: - SyncableEntity

public protocol SyncableEntity {
  associatedtype ReadOnlyModel: Sendable

  static func predicateForModel(_ model: ReadOnlyModel) -> NSPredicate

  func updateEntityFrom(_ model: ReadOnlyModel, on storage: StorageType) throws
  func populateEntityFrom(_ model: ReadOnlyModel, on storage: StorageType) throws
}

// MARK: - CoreDataSyncError

enum CoreDataSyncError: Error {
  case invalidContext
}

extension NSManagedObject { }
