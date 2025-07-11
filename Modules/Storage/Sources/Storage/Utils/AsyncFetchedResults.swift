import CoreData
import Foundation
import os
import Principle

public class AsyncFetchedResults<T: EntityType>: NSObject, NSFetchedResultsControllerDelegate, @unchecked Sendable {
    enum Event {
        case didUpdateContent([T.ReadOnlyType])
        case didInsertModel(T.ReadOnlyType)
        case didDeleteModel(T.ReadOnlyType)
        case didUpdateModel(T.ReadOnlyType)
        case didReceiveError(Error)
    }

    lazy var stream: AsyncStream<Event> = AsyncStream { (continuation: AsyncStream<Event>.Continuation) in
        self.continuation = continuation
        self.continuation?.onTermination = { _ in
            self.continuation = nil
            self.fetchedResultsController.delegate = self
        }
    }

    var continuation: AsyncStream<Event>.Continuation?
    var sortDescriptors: [NSSortDescriptor]
    var fetchLimit: Int?

    private var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>
    private let logger = Logger()

    var predicate: NSPredicate? {
        didSet {
            if let predicate, fetchedResultsController.delegate != nil {
                fetchedResultsController.fetchRequest.predicate = predicate
                performFetch()
            }
        }
    }

    var fetchedObjects: [T.ReadOnlyType] {
        guard let fetchedObjects = fetchedResultsController.fetchedObjects as? [T] else {
            return []
        }
        return fetchedObjects.map { $0.toReadOnly() }
    }

    init(sortDescriptors: [NSSortDescriptor] = [], predicate: Principle.Predicate<T>? = nil, fetchLimit: Int? = nil) {
        self.sortDescriptors = sortDescriptors
        self.fetchLimit = fetchLimit
        self.predicate = predicate

        fetchedResultsController = CoreDataStore.readOnlyStore().createFetchedResultsController(
            forType: T.self,
            matching: predicate,
            sortDescriptors: sortDescriptors,
            fetchLimit: fetchLimit,
            sectionNameKeyPath: nil,
            cacheName: nil)

        super.init()

        fetchedResultsController.delegate = self
        performFetch()
    }

    func performFetch() {
        do {
            try fetchedResultsController.performFetch()
            sendFetchedObjects(fetchedResultsController.fetchedObjects)
        } catch {
            continuation?.yield(.didReceiveError(error))
        }
    }

    private func sendFetchedObjects(_ fetchedObjects: [any NSFetchRequestResult]?) {
        guard let continuation, let fetchedObjects = fetchedObjects as? [T] else {
            return
        }

        let readOnlyObjects = fetchedObjects.map { $0.toReadOnly() }
        continuation.yield(.didUpdateContent(readOnlyObjects))
    }

    public func controller(
        _: NSFetchedResultsController<any NSFetchRequestResult>,
        didChange anObject: Any,
        at _: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath _: IndexPath?)
    {
        guard let entityObject = anObject as? T else {
            return
        }

        let readOnlyObject = entityObject.toReadOnly()
        switch type {
        case .insert:
            continuation?.yield(.didInsertModel(readOnlyObject))
            logger.info("Did insert object \(T.entityName): \(entityObject.objectID)")

        case .update:
            continuation?.yield(.didUpdateModel(readOnlyObject))
            logger.info("Did update object \(T.entityName): \(entityObject.objectID)")

        case .delete:
            continuation?.yield(.didDeleteModel(readOnlyObject))
            logger.info("Did delete object \(T.entityName): \(entityObject.objectID)")

        default:
            return
        }
    }
}
