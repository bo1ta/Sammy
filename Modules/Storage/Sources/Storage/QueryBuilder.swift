import CoreData
import Principle

class QueryBuilder<Entity: NSManagedObject> {
    private let context: NSManagedObjectContext
    private var predicate: NSPredicate?
    private var sortDescriptors: [NSSortDescriptor] = []
    private var limit: Int?

    init(on context: NSManagedObjectContext) {
        self.context = context
    }

    func filter(_ predicate: NSPredicate) -> Self {
        self.predicate = self.predicate.map { NSCompoundPredicate(andPredicateWithSubpredicates: [$0, predicate]) } ?? predicate
        return self
    }

    func filter(_ predicate: Principle.Predicate<Entity>) -> Self {
        self.predicate = self.predicate.map { NSCompoundPredicate(andPredicateWithSubpredicates: [$0, predicate]) } ?? predicate
        return self
    }

    func sort<T>(_ keyPath: KeyPath<Entity, T>, ascending: Bool) -> Self {
        let descriptor = NSSortDescriptor(
            key: NSExpression(forKeyPath: keyPath).keyPath,
            ascending: ascending)
        sortDescriptors.append(descriptor)
        return self
    }

    func limit(_ count: Int) -> Self {
        self.limit = count
        return self
    }

    func all() throws -> [Entity] {
        let request = Entity.fetchRequest()
        request.predicate = self.predicate
        request.sortDescriptors = self.sortDescriptors

        if let limit = self.limit {
            request.fetchLimit = limit
        }

        return try self.context.fetch(request) as? [Entity] ?? []
    }

    func first() throws -> Entity? {
        limit(1)
        return try all().first
    }

    func count() async throws -> Int {
        let request = Entity.fetchRequest()
        request.predicate = self.predicate
        return try self.context.count(for: request)
    }
}
