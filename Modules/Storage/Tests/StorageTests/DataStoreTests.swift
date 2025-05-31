import Factory
import Testing

@testable import Models
@testable import Storage

@Suite(.serialized)
struct DataStoreTests {
    @Test
    func importModels() async throws {
        let store = DataStore<Storage.PersonAttributes>()
        let personA = PersonAttributesFactory.create()
        let personB = PersonAttributesFactory.create()
        let persons = [personA, personB]

        await #expect(store.contains(where: \.uniqueID == personA.id) == false)
        await #expect(store.contains(where: \.uniqueID == personB.id) == false)

        try await store.importModels(persons)
        await #expect(store.contains(where: \.uniqueID == personA.id) == true)
        await #expect(store.contains(where: \.uniqueID == personB.id) == true)
    }

    @Test
    func getAll() async throws {
        let store = DataStore<Storage.Community>()

        let communities = CommunityFactory.createList(count: 5)
        try await store.importModels(communities)

        await #expect(store.getAll().count == 5)
    }

    @Test
    func getAllMatchingPredicate() async throws {
        let store = DataStore<Storage.Comment>()
        let mockPerson = try #require(try await PersonAttributesFactory.create().persisting())

        let mockComments = CommentFactory.createList(count: 3) { comment, _ in
            comment.commentAttributes.creatorID = mockPerson.id
        }
        try await store.importModels(mockComments)

        /// add 2 more comments, unreleated to the`mockPerson`
        try await store.importModels(CommentFactory.createList(count: 2))

        await #expect(store.getAll(matching: \.commentAttributes.creatorID == mockPerson.id).count == 3)
    }

    @Test
    func firstMatchingPredicate() async throws {
        let person = try await PersonAttributesFactory.create().persisting()

        let store = DataStore<Storage.PersonAttributes>()
        let localPerson = await store.first(where: \.uniqueID == person.id)
        #expect(localPerson?.id == person.id)
    }

    @Test
    func countMatchingPredicate() async throws {
        let store = DataStore<Storage.CommentAttributes>()
        let mockPerson = try await PersonAttributesFactory.create().persisting()

        let mockComments = CommentAttributesFactory.createList(count: 3) { commentAttributes, _ in
            commentAttributes.creatorID = mockPerson.id
        }
        try await store.importModels(mockComments)

        /// add 2 more comments, unreleated to the`mockPerson`
        try await store.importModels(CommentAttributesFactory.createList(count: 2))

        await #expect(store.count(matching: \.creatorID == mockPerson.id) == 3)
    }

    @Test
    func containsPredicate() async throws {
        let store = DataStore<Storage.CommentCounts>()
        let mockCommentCount = try await CommentCountsFactory.create().persisting()
        #expect(await store.contains(where: \.commentID == mockCommentCount.commentID))
    }

    @Test
    func updateField() async throws {
        let store = DataStore<Storage.PersonAttributes>()
        let mockPerson = try await PersonAttributesFactory.create(name: "Johnny Blaze").persisting()
        let predicate: Principle.Predicate<Storage.PersonAttributes> = \.uniqueID == mockPerson.id
        #expect(await store.first(where: predicate)?.name == "Johnny Blaze")

        try await store.updateField(matching: predicate, keyPath: \.name, to: "John Doe")
        #expect(await store.first(where: predicate)?.name == "John Doe")
    }
}
