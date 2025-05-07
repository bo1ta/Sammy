@preconcurrency import CoreData
import Foundation
import OSLog

// MARK: - StorageManager

public final class StorageManager: StorageManagerType, @unchecked Sendable {
    public static let shared = StorageManager()

    private let logger = Logger(subsystem: "com.Sammy.Storage", category: "StorageManager")

    lazy var persistentContainer: NSPersistentContainer = {
        guard
            let modelURL = Bundle.module.url(forResource: "SammyDataModel", withExtension: ".momd"),
            let model = NSManagedObjectModel(contentsOf: modelURL)
        else {
            fatalError("Could not load Core Data model")
        }

        let container = NSPersistentContainer(name: "MusculosDataStore", managedObjectModel: model)

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

    init() { }

    public var viewStorage: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    public lazy var writerDerivedStorage: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.parent = persistentContainer.viewContext
        managedObjectContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        return managedObjectContext
    }()

    public func saveChanges() async {
        await writerDerivedStorage.perform {
            self.writerDerivedStorage.saveIfNeeded()
        }
        await viewStorage.perform {
            self.viewStorage.saveIfNeeded()
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

extension NSManagedObjectContext {
    func saveIfNeeded() {
        guard hasChanges else {
            return
        }

        do {
            try save()
        } catch {
            rollback()
        }
    }
}
