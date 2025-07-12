import Combine
@preconcurrency import CoreData
import Foundation
import os

// MARK: - SharedStore

private class SharedStore {
  private let lock = NSLock()

  private var inMemoryOverride: InMemoryCoreDataStore?
  private var sharedInstance: CoreDataStore?

  func setOverride(_ store: InMemoryCoreDataStore?) {
    lock.withLock {
      inMemoryOverride = store
    }
  }

  func getShared() -> CoreDataStore {
    lock.withLock {
      if let inMemoryOverride {
        return inMemoryOverride
      }
      if sharedInstance == nil {
        sharedInstance = CoreDataStore()
      }
      // swiftlint:disable:next force_unwrapping
      return sharedInstance!
    }
  }
}

// MARK: - CoreDataStore

public class CoreDataStore: @unchecked Sendable, CoreDataManageable {
  private nonisolated(unsafe) static let sharedStore = SharedStore()

  private static var shared: CoreDataStore {
    sharedStore.getShared()
  }

  public static func setOverride(_ store: InMemoryCoreDataStore?) {
    sharedStore.setOverride(store)
  }

  private let logger = Logger()
  private var cancellables = Set<AnyCancellable>()

  public init() {
    setupNotificationPublisher()
  }

  private func setupNotificationPublisher() {
    NotificationCenter.default.publisher(
      for: .NSManagedObjectContextObjectsDidChange,
      object: writerDerivedStorage as? NSManagedObjectContext)
      .debounce(for: .seconds(coalesceSaveInterval), scheduler: DispatchQueue.global())
      .sink { [weak self] _ in
        self?.saveChanges(completion: { })
      }
      .store(in: &cancellables)
  }

  public var coalesceSaveInterval: Double { 0.3 }

  // MARK: - Migration

  private static let dataModelVersion = "1"
  private static let coreDataModelVersionKey = "CoreDataModelVersion"

  private func shouldRecreateDataStore() -> Bool {
    guard let version = UserDefaults.standard.string(forKey: Self.coreDataModelVersionKey) else {
      return false
    }
    return version != Self.dataModelVersion
  }

  private func updateDataModelVersion() {
    UserDefaults.standard.setValue(Self.dataModelVersion, forKey: Self.coreDataModelVersionKey)
  }

  private lazy var _persistentContainer: NSPersistentContainer = {
    guard
      let modelURL = Bundle.module.url(forResource: "SammyDataModel", withExtension: ".momd"),
      let model = NSManagedObjectModel(contentsOf: modelURL)
    else {
      fatalError("Could not load Core Data model")
    }

    let container = NSPersistentContainer(name: "SammyDataStore", managedObjectModel: model)
    defer { updateDataModelVersion() }

    let description = container.persistentStoreDescriptions.first
    description?.type = NSSQLiteStoreType
    description?.shouldMigrateStoreAutomatically = true
    description?.shouldInferMappingModelAutomatically = true

    if shouldRecreateDataStore(), let storeURL = description?.url {
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

  public var persistentContainer: NSPersistentContainer { _persistentContainer }

  public var viewStorage: StorageType {
    persistentContainer.viewContext
  }

  public lazy var writerDerivedStorage: StorageType = {
    let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    managedObjectContext.parent = persistentContainer.viewContext
    managedObjectContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
    return managedObjectContext
  }()

  public var viewContextForNotifications: NSManagedObjectContext {
    // swiftlint:disable:next force_cast
    viewStorage as! NSManagedObjectContext
  }

  public static func manager() -> CoreDataManageable {
    shared
  }

  public static func writeOnlyStore() -> WriteOnlyStore {
    shared
  }

  public static func readOnlyStore() -> ReadOnlyStore {
    shared
  }

  @discardableResult
  public func performWrite<ResultType>(
    _ saveSchedule: SaveSchedule,
    _ writeClosure: @escaping WriteStorageClosure<ResultType>)
    async throws -> ResultType
  {
    try await writerDerivedStorage.perform {
      let result = try writeClosure(self.writerDerivedStorage)

      switch saveSchedule {
      case .now:
        self.writerDerivedStorage.saveIfNeeded()
      case .scheduled:
        (self.writerDerivedStorage as? NSManagedObjectContext)?.processPendingChanges()
      }

      return result
    }
  }

  public func saveChanges(completion: @escaping () -> Void) {
    writerDerivedStorage.perform { [weak self] in
      guard let self else {
        return
      }

      writerDerivedStorage.saveIfNeeded()

      viewStorage.perform {
        self.viewStorage.saveIfNeeded()
        completion()
      }
    }
  }

  public func saveChanges() async {
    await writerDerivedStorage.perform { self.writerDerivedStorage.saveIfNeeded() }
    await viewStorage.perform { self.viewStorage.saveIfNeeded() }
  }

  public func reset() {
    let viewContext = persistentContainer.viewContext
    viewContext.performAndWait {
      viewContext.reset()
      self.deleteAllStoredObjects()
      logger.info("CoreDataStack DESTROYED ! 💣")
    }
  }

  func deleteSql() {
    let url = FileManager.default
      .urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
      .appendingPathComponent("DataModel.sqlite")

    guard FileManager.default.fileExists(atPath: url.path) else {
      logger.error("Could not find sqlite db")
      return
    }

    do {
      try persistentContainer.persistentStoreCoordinator.destroyPersistentStore(at: url, type: .sqlite)
    } catch {
      logger.error("Could not destroy persistent store. Error: \(error)")
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
