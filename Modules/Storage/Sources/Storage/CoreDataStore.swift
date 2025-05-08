import Factory
import CoreData
import Models
import OSLog
import Principle

public struct CoreDataStore {
    @Injected(\.storageManager) private var storageManager: StorageManagerType

    private let logger = Logger(subsystem: "com.Sammy.Storage", category: "CoreDataStore")

    public func personByID(_ id: Models.Person.ID) async -> Models.Person? {
        await storageManager.performRead { context in
            Person.query(on: context)
                .first(where: \.uniqueID == id)?
                .toReadOnly()
        }
    }

    public func personByName(_ name: String) async -> Models.Person? {
        await storageManager.performRead { context in
            Person.query(on: context)
                .first(where: \.name == name)?
                .toReadOnly()
        }
    }

    public func savePerson(_ person: Models.Person) async throws {
        try await storageManager.performWrite(.immediate) { context in
            _ = try person.toEntity(in: context)

            context.saveIfNeeded()
        }
    }
}
