import CoreData
import Factory
import Models
import OSLog
import Principle

public struct CoreDataStore {
    @Injected(\.storageManager) private var storageManager: StorageManagerType

    public func personByID(_ id: Models.PersonAttributes.ID) async -> Models.PersonAttributes? {
        await storageManager.performRead { context in
            Person.query(on: context)
                .first(where: \.uniqueID == id)?
                .toReadOnly()
        }
    }

    public func personByName(_ name: String) async -> Models.PersonAttributes? {
        await storageManager.performRead { context in
            Person.query(on: context)
                .first(where: \.name == name)?
                .toReadOnly()
        }
    }

    public func savePerson(_ person: Models.PersonAttributes) async throws {
        try await storageManager.performWrite(.immediate) { context in
            _ = try person.toEntity(in: context)

            context.saveIfNeeded()
        }
    }
}
