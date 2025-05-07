import CoreData
import Models
import OSLog
import Principle

public struct CoreDataStore {
    private let logger = Logger(subsystem: "com.Sammy.Storage", category: "CoreDataStore")
    private let storageManager: StorageManagerType

    public init(storageManager: StorageManagerType = StorageManager.shared) {
        self.storageManager = storageManager
    }

    public func personByID(_ id: Models.Person.ID) async -> Models.Person? {
        await storageManager.performRead { context in
            do {
                return try Person.query(on: context)
                    .filter(\.uniqueID == id)
                    .first()?
                    .toReadOnly()
            } catch {
                logger.error("Error fetching person: \(error)")
                return nil
            }
        }
    }
}
