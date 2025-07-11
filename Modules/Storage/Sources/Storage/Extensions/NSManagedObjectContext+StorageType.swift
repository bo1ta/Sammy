import CoreData
import Foundation
import os

private let logger = Logger()

// MARK: - NSManagedObjectContext + StorageType

extension NSManagedObjectContext: StorageType {
    public var parentStorage: StorageType? {
        parent
    }

    public func allObjects<T: Object>(
        ofType type: T.Type,
        matching predicate: NSPredicate?,
        sortedBy descriptors: [NSSortDescriptor]?)
        -> [T]
    {
        let request = fetchRequest(forType: type)
        request.predicate = predicate
        request.sortDescriptors = descriptors

        return loadObjects(ofType: type, with: request)
    }

    public func allObjects<T: Object>(
        ofType type: T.Type,
        matching predicate: NSPredicate?,
        relationshipKeyPathsForPrefetching: [String])
        -> [T]
    {
        let request = fetchRequest(forType: type)
        request.predicate = predicate
        request.relationshipKeyPathsForPrefetching = relationshipKeyPathsForPrefetching

        return loadObjects(ofType: type, with: request)
    }

    public func allObjects<T: Object>(
        ofType type: T.Type,
        fetchLimit: Int,
        matching predicate: NSPredicate?,
        sortedBy descriptors: [NSSortDescriptor]?)
        -> [T]
    {
        let request = fetchRequest(forType: type)
        request.predicate = predicate
        request.sortDescriptors = descriptors
        request.fetchLimit = fetchLimit

        return loadObjects(ofType: type, with: request)
    }

    public func countObjects(ofType type: (some Object).Type) -> Int {
        countObjects(ofType: type, matching: nil)
    }

    public func countObjects(ofType type: (some Object).Type, matching predicate: NSPredicate?) -> Int {
        let request = fetchRequest(forType: type)
        request.predicate = predicate
        request.resultType = .countResultType

        var result = 0

        do {
            result = try count(for: request)
        } catch {
            logger.error("Unable to count objects \(error)")
        }

        return result
    }

    public func deleteObject(_ object: some Object) {
        guard let object = object as? NSManagedObject else {
            logger.error("Cannot delete object! Invalid kind")
            return
        }

        delete(object)
    }

    func deleteAllObjects(ofType type: (some Object).Type) {
        let request = fetchRequest(forType: type)
        request.includesPropertyValues = false
        request.includesSubentities = false

        for object in loadObjects(ofType: type, with: request) {
            deleteObject(object)
        }
    }

    public func firstObject<T: Object>(of type: T.Type) -> T? {
        firstObject(of: type, matching: nil)
    }

    public func firstObject<T: Object>(of type: T.Type, matching predicate: NSPredicate?) -> T? {
        let request = fetchRequest(forType: type)
        request.predicate = predicate
        request.fetchLimit = 1

        return loadObjects(ofType: type, with: request).first
    }

    public func insertNewObject<T: Object>(ofType _: T.Type) -> T {
        NSEntityDescription.insertNewObject(forEntityName: T.entityName, into: self) as! T // swiftlint:disable:this force_cast
    }

    public func loadObject<T: Object>(ofType _: T.Type, with objectID: T.ObjectID) -> T? {
        guard let objectID = objectID as? NSManagedObjectID else {
            logger.error("Cannot find objectID in context")
            return nil
        }

        do {
            return try existingObject(with: objectID) as? T
        } catch {
            logger.error("Error loading object. Error: \(error)")
        }

        return nil
    }

    public func findOrInsert<T: Object>(of type: T.Type, using predicate: NSPredicate) -> T {
        if let existingObject = firstObject(of: type, matching: predicate) {
            return existingObject
        }
        return insertNewObject(ofType: type)
    }

    public func saveIfNeeded() {
        guard hasChanges else {
            return
        }

        do {
            try save()
        } catch {
            rollback()
            logger.error("Failed to save context. Error: \(error)")
        }
    }

    public func fetchUniquePropertyValues(of type: (some Object).Type, property propertyToFetch: String) -> Set<UUID> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: type.entityName)
        fetchRequest.resultType = .dictionaryResultType
        fetchRequest.propertiesToFetch = [propertyToFetch]

        do {
            guard let results = try fetch(fetchRequest) as? [[String: Any]] else {
                return []
            }
            return Set<UUID>(results.compactMap { dict in
                dict[propertyToFetch] as? UUID
            })
        } catch {
            logger.error("Cannot fetch by property. Error: \(error)")
            return []
        }
    }

    /// Loads the collection of entities that match with a given Fetch Request
    ///
    private func loadObjects<T: Object>(ofType _: T.Type, with request: NSFetchRequest<NSFetchRequestResult>) -> [T] {
        var objects: [T]?

        do {
            objects = try fetch(request) as? [T]
        } catch {
            logger.error("Could not load objects. Error: \(error)")
        }
        return objects ?? []
    }

    /// Returns a NSFetchRequest instance with its *Entity Name* always set, for the specified Object Type.
    ///
    private func fetchRequest(forType type: (some Object).Type) -> NSFetchRequest<NSFetchRequestResult> {
        NSFetchRequest<NSFetchRequestResult>(entityName: type.entityName)
    }

    public func perform<ResultType>(_ block: @escaping () throws -> ResultType) async throws -> ResultType {
        try await withCheckedThrowingContinuation { [weak self] continuation in
            guard let self else {
                return
            }

            perform {
                do {
                    let result = try block()
                    continuation.resume(returning: result)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    public func perform<ResultType>(_ block: @escaping () -> ResultType) async -> ResultType {
        await withCheckedContinuation { continuation in

            self.perform {
                let result = block()
                continuation.resume(returning: result)
            }
        }
    }

    public func performAndBlock<ResultType>(_ block: () -> ResultType) -> ResultType {
        self.performAndWait {
            block()
        }
    }

    public func createFetchedResultsController(
        for type: (some Object).Type,
        predicate: NSPredicate?,
        sortDescriptors: [NSSortDescriptor],
        fetchLimit: Int?,
        sectionNameKeyPath: String?,
        cacheName: String?)
        -> NSFetchedResultsController<NSFetchRequestResult>
    {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: type.entityName)
        fetchRequest.sortDescriptors = sortDescriptors
        fetchRequest.predicate = predicate

        if let fetchLimit {
            fetchRequest.fetchLimit = fetchLimit
        }

        return NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: self,
            sectionNameKeyPath: sectionNameKeyPath,
            cacheName: cacheName)
    }

    public func batchUpdate(
        ofType type: (some Object).Type,
        matching predicate: NSPredicate?,
        updates: [String: Any])
        throws -> Int
    {
        let batchRequest = NSBatchUpdateRequest(entityName: type.entityName)
        batchRequest.predicate = predicate
        batchRequest.propertiesToUpdate = updates
        batchRequest.resultType = .updatedObjectsCountResultType

        let result = try execute(batchRequest) as? NSBatchUpdateResult
        return result?.result as? Int ?? 0
    }

    public func batchDelete(ofType type: (some Object).Type, matching predicate: NSPredicate?) throws -> Int {
        let fetchRequest = fetchRequest(forType: type)
        fetchRequest.predicate = predicate

        let batchRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        batchRequest.resultType = .resultTypeCount

        let result = try execute(batchRequest) as? NSBatchDeleteResult
        return result?.result as? Int ?? 0
    }

    public func findOrInsert<T: SyncableEntity & Object>(of type: T.Type, usingDTO model: T.ReadOnlyModel) throws -> T {
        if let existing = firstObject(of: type, matching: T.predicateForModel(model)) {
            try existing.updateEntityFrom(model, on: self)
            return existing
        } else {
            let newEntity = insertNewObject(ofType: type)
            try newEntity.populateEntityFrom(model, on: self)
            return newEntity
        }
    }

    public func updateToManyRelationship<Entity: SyncableEntity & Object>(
        models: some Sequence<Entity.ReadOnlyModel>,
        currentEntities: Set<Entity>,
        compare: @escaping (Entity.ReadOnlyModel, Entity) -> Bool,
        add: @escaping (Set<Entity>) -> Void,
        remove: @escaping (Set<Entity>) -> Void)
        throws
    {
        /// Remove entities not present in models
        let entitiesToRemove = currentEntities.filter { entity in
            !models.contains { model in compare(model, entity) }
        }
        if !entitiesToRemove.isEmpty {
            remove(entitiesToRemove)
        }

        /// Update existing or insert new
        var entitiesToAdd: Set<Entity> = []
        try models.forEach { model in
            try self.findOrInsert(of: Entity.self, usingDTO: model)
        }

        /// Add new entities
        if !entitiesToAdd.isEmpty {
            add(entitiesToAdd)
        }
    }
}
