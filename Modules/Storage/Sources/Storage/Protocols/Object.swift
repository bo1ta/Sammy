import Foundation

// MARK: - Object

public protocol Object: AnyObject {
  associatedtype ObjectID

  var objectID: ObjectID { get }

  static var entityName: String { get }
  static var expirationDeadline: ExpirationDeadline { get }
}

extension Object {
  public static var expirationDeadline: ExpirationDeadline { .oneWeek }
}
