import Foundation
import Testing

@testable import Models
@testable import Storage

@Suite
struct CoreDataStoreTests {
    private let store = CoreDataStore()

    @Test
    func personByID() async throws {
        let person = PersonBuilder().build()
        await #expect(store.personByID(person.id) == nil)

        try await store.savePerson(person)
        await #expect(store.personByID(person.id) != nil)
    }

    @Test
    func personByName() async throws {
        let person = PersonBuilder().build()
        await #expect(store.personByName(person.name) == nil)

        try await store.savePerson(person)
        await #expect(store.personByName(person.name) != nil)
    }
}
