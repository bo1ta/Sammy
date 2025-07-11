//
//  AsyncEntityListener.swift
//  LifeCoach
//
//  Created by Alexandru Solomon on 09.06.2025.
//

import CoreData
import Foundation
import os

public class AsyncEntityListener<T: EntityType>: @unchecked Sendable {
    lazy var stream: AsyncStream<T.ReadOnlyType> = AsyncStream { (continuation: AsyncStream<T.ReadOnlyType>.Continuation) in
        self.continuation = continuation
        self.continuation?.onTermination = { _ in
            self.continuation = nil
        }
    }

    var continuation: AsyncStream<T.ReadOnlyType>.Continuation?
    var predicate: NSPredicate

    public init(predicate: NSPredicate) {
        self.predicate = predicate

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleNotification(_:)),
            name: .NSManagedObjectContextObjectsDidChange,
            object: CoreDataStore.manager().viewContextForNotifications)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc
    private func handleNotification(_ notification: Notification) {
        let updated = notification.userInfo?[NSUpdatedObjectsKey] as? Set<NSManagedObject> ?? []
        let inserted = notification.userInfo?[NSInsertedObjectsKey] as? Set<NSManagedObject> ?? []

        guard
            let updatedObject = updated.union(inserted)
                .compactMap({ $0 as? T })
                .first(where: { predicate.evaluate(with: $0) })?
                .toReadOnly()
        else {
            return
        }

        continuation?.yield(updatedObject)
    }
}
