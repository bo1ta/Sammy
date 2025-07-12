import Foundation
import Storage

// MARK: - DataProvider

protocol DataProvider {
  var readOnlyStore: ReadOnlyStore { get }
  var writeOnlyStore: WriteOnlyStore { get }
}

extension DataProvider {
  var readOnlyStore: ReadOnlyStore {
    CoreDataStore.readOnlyStore()
  }

  var writeOnlyStore: WriteOnlyStore {
    CoreDataStore.writeOnlyStore()
  }
}
