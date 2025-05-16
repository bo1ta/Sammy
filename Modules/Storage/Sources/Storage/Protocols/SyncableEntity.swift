import CoreData
import Foundation
import Principle

public protocol SyncableEntity {
    associatedtype ReadOnlyModel: Storable

    static func predicateForModel(_ model: ReadOnlyModel) -> NSPredicate
    @discardableResult
    func updateEntityFrom(_ model: ReadOnlyModel) throws -> Self
}
