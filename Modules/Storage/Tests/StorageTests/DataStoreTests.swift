import Foundation
import Testing

@testable import Models
@testable import Storage

@Suite
struct DataStoreTests {
    @Test
    func importModel() async throws {
        let store = DataStore<Person>()
        let person = PersonBuilder().build()
        
        await #expect(store.first(where: \.uniqueID == person.id) == nil)

        try await store.importModel(person)
        await #expect(store.first(where: \.uniqueID == person.id) != nil)
    }

    @Test
    func importModels() async throws {
        let store = DataStore<Person>()
        let personA = PersonBuilder().build()
        let personB = PersonBuilder().build()
        let persons = [personA, personB]

        await #expect(store.first(where: \.uniqueID == personA.id) == nil)
        await #expect(store.first(where: \.uniqueID == personB.id) == nil)

        try await store.importModels(persons)
        await #expect(store.first(where: \.uniqueID == personA.id) != nil)
        await #expect(store.first(where: \.uniqueID == personA.id) != nil)
    }

    @Test
    func firstMatchingPredicate() async throws {
        let person = PersonBuilder()
            .withName("Johnny")
            .build()

        let store = DataStore<Person>()
        _ = try await store.importModel(person)
        

        let localPerson = await store.first(where: \.name == person.name)
        #expect(localPerson?.id == person.id)
    }
}
