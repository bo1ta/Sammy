import CoreData
import OSLog

public class InMemoryStorageManager: StorageManagerType {
    public var viewStorage: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    public lazy var writerDerivedStorage: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.parent = persistentContainer.viewContext
        return managedObjectContext
    }()

    public func reset() { }

    private let logger = Logger(subsystem: "com.Sammy.Storage", category: "InMemoryStorageManager")

    lazy var persistentContainer: NSPersistentContainer = {
        guard
            let modelURL = Bundle.module.url(forResource: "SammyDataModel", withExtension: ".momd"),
            let model = NSManagedObjectModel(contentsOf: modelURL)
        else {
            fatalError("Could not load Core Data model")
        }

        let description = NSPersistentStoreDescription(url: URL(filePath: "/dev/null"))
        description.type = NSInMemoryStoreType
        description.shouldMigrateStoreAutomatically = true
        description.shouldInferMappingModelAutomatically = true

        let container = NSPersistentContainer(name: "LifeCoachDataStore", managedObjectModel: model)
        container.persistentStoreDescriptions = [description]

        container.loadPersistentStores { _, error in
            if let error {
                self.logger.error("Failed to load persistent store. Error: \(error)")
            }
        }
        return container
    }()

    public func performWrite<ResultType>(
        _ schedule: NSManagedObjectContext.ScheduledTaskType = .immediate,
        _ writeClosure: @escaping (NSManagedObjectContext) throws -> ResultType?)
        async throws -> ResultType?
    {
        try await writerDerivedStorage.perform(schedule: schedule) {
            let result = try writeClosure(self.writerDerivedStorage)
            self.writerDerivedStorage.saveIfNeeded()
            return result
        }
    }
}
