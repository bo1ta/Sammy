@preconcurrency import CoreData
import Foundation
import Combine
import OSLog

// MARK: - StorageManager

public final class StorageManager: StorageManagerType, @unchecked Sendable {
    public static let shared = StorageManager()

    private let logger = Logger(subsystem: "com.Sammy.Storage", category: "StorageManager")
    private let coalesceSaveInterval = 0.5

    private var cancellables: Set<AnyCancellable> = []

    lazy var persistentContainer: NSPersistentContainer = {
        guard
            let modelURL = Bundle.module.url(forResource: "SammyDataModel", withExtension: ".momd"),
            let model = NSManagedObjectModel(contentsOf: modelURL)
        else {
            fatalError("Could not load Core Data model")
        }

        let container = NSPersistentContainer(name: "SammyDataStore", managedObjectModel: model)

        let description = container.persistentStoreDescriptions.first
        description?.type = NSSQLiteStoreType
        description?.shouldMigrateStoreAutomatically = true
        description?.shouldInferMappingModelAutomatically = true

        if let storeURL = description?.url {
            do {
                try container.persistentStoreCoordinator.destroyPersistentStore(at: storeURL, type: .sqlite)
                logger.info("Deleted persistent store for forced migration")
            } catch {
                logger.error("Failed to delete persistent store. Error: \(error)")
            }
        }

        container.loadPersistentStores { _, error in
            if let error {
                self.logger.error("Failed to load persistent store. Error: \(error)")
            }
        }

        return container
    }()

    public var viewStorage: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    public lazy var writerDerivedStorage: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.parent = persistentContainer.viewContext
        managedObjectContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        return managedObjectContext
    }()

    init() {
        NotificationCenter.default.publisher(for: .NSManagedObjectContextObjectsDidChange, object: writerDerivedStorage)
        .debounce(for: .seconds(coalesceSaveInterval), scheduler: DispatchQueue.global())
        .sink { [weak self] _ in
            self?.saveChangesWithClosure()
        }
        .store(in: &cancellables)
    }

    @discardableResult
    public func performWrite<ResultType>(
        _ schedule: NSManagedObjectContext.ScheduledTaskType = .immediate,
        _ writeClosure: @escaping (NSManagedObjectContext) throws -> ResultType)
        async throws -> ResultType
    {
        try await writerDerivedStorage.perform(schedule: schedule) {
            let result = try writeClosure(self.writerDerivedStorage)
            self.writerDerivedStorage.processPendingChanges()
            return result
        }
    }

    public func reset() {
        let viewContext = persistentContainer.viewContext
        viewContext.performAndWait {
            viewContext.reset()
            self.deleteAllStoredObjects()
            logger.info("CoreDataStack DESTROYED ! 💣")
        }
    }

    func deleteAllStoredObjects() {
        let viewContext = persistentContainer.viewContext

        for entity in persistentContainer.persistentStoreCoordinator.managedObjectModel.entities {
            guard let entityName = entity.name else {
                continue
            }

            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)

            do {
                let objects = try viewContext.fetch(fetchRequest)
                for object in objects {
                    viewContext.delete(object)
                }
                viewContext.saveIfNeeded()
            } catch {
                logger.error("Failed to fetch objects for entity \(entityName): \(error)")
            }
        }
    }
}

