import Foundation
import Principle
import CoreData

public protocol SyncableEntity {
    associatedtype ReadOnlyModel: Storable

    static func predicateForModel(_ model: ReadOnlyModel) -> NSPredicate
    @discardableResult func updateEntityFrom(_ model: ReadOnlyModel) throws -> Self
}
