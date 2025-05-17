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

        await #expect(store.contains(where: \.uniqueID == person.id) == false)

        try await store.importModel(person)
        await #expect(store.contains(where: \.uniqueID == person.id) == true)
    }

    @Test
    func importModels() async throws {
        let store = DataStore<Person>()
        let personA = PersonBuilder().build()
        let personB = PersonBuilder().build()
        let persons = [personA, personB]

        await #expect(store.contains(where: \.uniqueID == personA.id) == false)
        await #expect(store.contains(where: \.uniqueID == personB.id) == false)

        try await store.importModels(persons)
        await #expect(store.contains(where: \.uniqueID == personA.id) == true)
        await #expect(store.contains(where: \.uniqueID == personB.id) == true)
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

    @Test
    func testImportPersonCounts() async throws {
        let mockModel = PersonCountsBuilder().build()

        let store = DataStore<Storage.PersonCounts>()
        try await store.importModel(mockModel)

        let localCounts = try #require(await store.first(where: \.personID == mockModel.personID))
        #expect(localCounts.postCount == mockModel.postCount)
    }

    @Test
    func testImportCommentAttributes() async throws {
        let mockModel = CommentAttributesFactory.create()

        let store = DataStore<Storage.CommentAttributes>()
        try await store.importModel(mockModel)

        let localCommentAttributes = try #require(await store.first(where: \.uniqueID == mockModel.id))
        #expect(localCommentAttributes == mockModel)
    }

}
