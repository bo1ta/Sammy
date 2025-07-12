import CoreData
import OSLog

public class InMemoryCoreDataStore: CoreDataStore {
  private let logger = Logger()

  private lazy var inMemoryContainer: NSPersistentContainer = {
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

  override public var persistentContainer: NSPersistentContainer { inMemoryContainer }

  override public func performWrite<ResultType>(
    _: SaveSchedule,
    _ writeClosure: @escaping WriteStorageClosure<ResultType>)
    async throws -> ResultType
  {
    try await writerDerivedStorage.perform {
      let result = try writeClosure(self.writerDerivedStorage)
      self.writerDerivedStorage.saveIfNeeded()
      return result
    }
  }
}
