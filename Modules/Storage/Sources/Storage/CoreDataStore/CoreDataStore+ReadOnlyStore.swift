import CoreData
import Models
import Principle

// MARK: - CoreDataStore + ReadOnlyStore

extension CoreDataStore: ReadOnlyStore {
  public func performRead<ResultType>(_ readClosure: @escaping ReadStorageClosure<ResultType>) async -> ResultType {
    await viewStorage.perform {
      readClosure(self.viewStorage)
    }
  }

  public func performBlockingRead<ResultType>(_ readClosure: @escaping ReadStorageClosure<ResultType>) -> ResultType {
    viewStorage.performAndBlock {
      readClosure(self.viewStorage)
    }
  }

  public func objectCount(ofType type: (some EntityType).Type, predicate: NSPredicate?) async -> Int {
    await performRead { storage in
      storage.countObjects(ofType: type, matching: predicate)
    }
  }

  public func allObjects<T: EntityType>(
    ofType type: T.Type,
    predicate: Principle.Predicate<T>?,
    sortedBy descriptors: [NSSortDescriptor]? = nil)
    async -> [T.ReadOnlyType]
  {
    await performRead { storage in
      storage.allObjects(ofType: type, matching: predicate, sortedBy: descriptors)
        .map { $0.toReadOnly() }
    }
  }

  public func allObjects<T: EntityType>(
    ofType type: T.Type,
    fetchLimit: Int,
    predicate: Principle.Predicate<T>?,
    sortedBy descriptors: [NSSortDescriptor]? = nil)
    async -> [T.ReadOnlyType]
  {
    await performRead { storage in
      storage.allObjects(ofType: type, fetchLimit: fetchLimit, matching: predicate, sortedBy: descriptors)
        .map { $0.toReadOnly() }
    }
  }

  public func firstObject<T: EntityType>(ofType type: T.Type, predicate: Principle.Predicate<T>?) async -> T.ReadOnlyType? {
    await performRead { storage in
      storage.firstObject(of: type, matching: predicate)?.toReadOnly()
    }
  }

  public func firstRandomObject<T: EntityType>(
    ofType type: T.Type,
    byUniqueProperty property: String,
    predicate: Principle.Predicate<T>? = nil)
    async -> T.ReadOnlyType?
  {
    await performRead { storage -> T.ReadOnlyType? in
      let uniqueProperties = storage.fetchUniquePropertyValues(of: type, property: property)

      guard let randomValue = uniqueProperties.randomElement() else {
        return nil
      }

      var randomValuePredicate = NSPredicate(format: "%K == %@", property, randomValue as NSUUID)
      if let predicate {
        randomValuePredicate = NSCompoundPredicate(type: .and, subpredicates: [randomValuePredicate, predicate])
      }
      return storage.firstObject(of: type, matching: randomValuePredicate)?.toReadOnly()
    }
  }

  public func entityListener<T: EntityType>(
    ofType _: T.Type,
    matching predicate: Principle.Predicate<T>)
    -> AsyncEntityListener<T>
  {
    AsyncEntityListener(predicate: predicate)
  }

  public func createFetchedResultsController<T: EntityType>(
    forType type: T.Type,
    matching predicate: Principle.Predicate<T>?,
    sortDescriptors: [NSSortDescriptor] = [],
    fetchLimit: Int? = nil,
    sectionNameKeyPath: String? = nil,
    cacheName: String? = nil)
    -> NSFetchedResultsController<NSFetchRequestResult>
  {
    viewStorage.createFetchedResultsController(
      for: type,
      predicate: predicate,
      sortDescriptors: sortDescriptors,
      fetchLimit: fetchLimit,
      sectionNameKeyPath: sectionNameKeyPath,
      cacheName: cacheName)
  }
}

extension ReadOnlyStore {
  public func allPosts() async -> [Models.Post] {
    await allObjects(ofType: PostEntity.self, predicate: nil, sortedBy: nil)
  }

  public func postByID(_ id: Post.ID) async -> Post? {
    await firstObject(ofType: PostEntity.self, predicate: \.postAttributes.uniqueID == id)
  }

  public func commentsForPostID(_ id: Post.ID) async -> [Comment] {
    await allObjects(ofType: CommentEntity.self, predicate: \.postAttributes.uniqueID == id, sortedBy: nil)
  }

  public func personByID(_ id: PersonAttributes.ID) async -> PersonAttributes? {
    await firstObject(ofType: PersonAttributesEntity.self, predicate: \.uniqueID == id)
  }

  public func localUserByPersonID(_ id: PersonAttributes.ID) async -> LocalUser? {
    await firstObject(ofType: LocalUserEntity.self, predicate: \.personAttributes.uniqueID == id)
  }
}
