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
    func firstMatchingPredicate() async throws {
        let person = PersonAttributesFactory.create()

        let store = DataStore<Storage.PersonAttributes>()
        _ = try await store.importModel(person)

        let localPerson = await store.first(where: \.name == person.name)
        #expect(localPerson?.id == person.id)
    }

    @Test
    func testImportPersonCounts() async throws {
        let mockModel = PersonCountsFactory.create()

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

    @Test
    func testImportCommentCounts() async throws {
        let mockModel = CommentCountsFactory.create()

        let store = DataStore<Storage.CommentCounts>()
        try await store.importModel(mockModel)

        let localCommentCounts = try #require(await store.first(where: \.commentID == mockModel.commentID))
        #expect(localCommentCounts.published == mockModel.published)
    }

    @Test
    func testImportComment() async throws {
        let mockModel = CommentFactory.create()

        let store = DataStore<Storage.Comment>()
        try await store.importModel(mockModel)

        let localComment = try #require(await store.first(where: \.commentID == mockModel.commentAttributes.id))
        #expect(localComment == mockModel)
    }

    @Test
    func testImportCommunityAttributes() async throws {
        let mockModel = CommunityAttributesFactory.create()

        let store = DataStore<Storage.CommunityAttributes>()
        try await store.importModel(mockModel)

        let localCommunityAttributes = try #require(await store.first(where: \.uniqueID == mockModel.id))
        #expect(localCommunityAttributes == mockModel)
    }

    @Test
    func testImportCommunityCounts() async throws {
        let mockModel = CommunityCountsFactory.create()

        let store = DataStore<Storage.CommunityCounts>()
        try await store.importModel(mockModel)

        let localCommunityCounts = try #require(await store.first(where: \.communityID == mockModel.communityID))
        #expect(localCommunityCounts == mockModel)
    }

    @Test
    func testImportCommunity() async throws {
        let mockModel = CommunityFactory.create()

        let store = DataStore<Storage.Community>()
        try await store.importModel(mockModel)

        let localCommunity = try #require(await store.first(where: \.communityAttributes.uniqueID == mockModel.attributes.id))
        #expect(localCommunity == mockModel)
    }

    @Test
    func testImportPostAttributes() async throws {
        let mockModel = PostAttributesFactory.create()

        let store = DataStore<Storage.PostAttributes>()
        try await store.importModel(mockModel)

        let localPostAttributes = try #require(await store.first(where: \.uniqueID == mockModel.id))
        #expect(localPostAttributes == mockModel)
    }

    @Test
    func testImportPostCounts() async throws {
        let mockModel = PostCountsFactory.create()

        let store = DataStore<Storage.PostCounts>()
        try await store.importModel(mockModel)

        let localPostCounts = try #require(await store.first(where: \.postID == mockModel.postID))
        #expect(localPostCounts == mockModel)
    }

    @Test
    func testImportSiteAttributes() async throws {
        let mockModel = SiteAttributesFactory.create()

        let store = DataStore<Storage.SiteAttributes>()
        try await store.importModel(mockModel)

        let localSiteAttributes = try #require(await store.first(where: \.uniqueID == mockModel.id))
        #expect(localSiteAttributes.description == mockModel.description)
    }

    @Test
    func testImportPost() async throws {
        let mockModel = PostFactory.create()

        let store = DataStore<Storage.Post>()
        try await store.importModel(mockModel)

        let localPost = try #require(await store.first(where: \.postAttributes.uniqueID == mockModel.postData.id))
        #expect(localPost == mockModel)
    }

    @Test

}
