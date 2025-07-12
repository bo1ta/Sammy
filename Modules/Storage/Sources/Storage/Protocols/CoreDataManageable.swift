import CoreData

public protocol CoreDataManageable {
  var viewContextForNotifications: NSManagedObjectContext { get }

  func reset()
}
