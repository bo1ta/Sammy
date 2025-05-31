import Factory
import Principle
import Testing

@testable import Models
@testable import Storage

@Suite(.serialized)
struct ImportEntityTests {

    // MARK: - Person

    @Test
    func importPersonCounts() async throws {
        let mockModel = PersonCountsFactory.create()

        let store = DataStore<Storage.PersonCounts>()
        try await store.importModel(mockModel)

        let localCounts = try #require(await store.first(where: \.personID == mockModel.personID))
        #expect(localCounts.postCount == mockModel.postCount)
    }

    @Test
    func importLocalUser() async throws {
        let mockModel = LocalUserFactory.create()

        let store = DataStore<Storage.LocalUser>()
        try await store.importModel(mockModel)

        let localUser = try #require(await store.first(where: \.localUserAttributes.uniqueID == mockModel.userAttributes.id))
        #expect(localUser.userAttributes.id == mockModel.userAttributes.id)
    }

    @Test
    func importLocalUserAttributes() async throws {
        let mockModel = LocalUserAttributesFactory.create()

        let store = DataStore<Storage.LocalUserAttributes>()
        try await store.importModel(mockModel)

        let localUser = try #require(await store.first(where: \.uniqueID == mockModel.id))
        #expect(localUser.defaultSortType == mockModel.defaultSortType)
    }

    // MARK: - Comments

    @Test
    func importCommentAttributes() async throws {
        let mockModel = CommentAttributesFactory.create()

        let store = DataStore<Storage.CommentAttributes>()
        try await store.importModel(mockModel)

        let localCommentAttributes = try #require(await store.first(where: \.uniqueID == mockModel.id))
        #expect(localCommentAttributes == mockModel)
    }

    @Test
    func importCommentCounts() async throws {
        let mockModel = CommentCountsFactory.create()

        let store = DataStore<Storage.CommentCounts>()
        try await store.importModel(mockModel)

        let localCommentCounts = try #require(await store.first(where: \.commentID == mockModel.commentID))
        #expect(localCommentCounts.published == mockModel.published)
    }

    @Test
    func importComment() async throws {
        let mockModel = CommentFactory.create()

        let store = DataStore<Storage.Comment>()
        try await store.importModel(mockModel)

        let localComment = try #require(await store.first(where: \.commentID == mockModel.commentAttributes.id))
        #expect(localComment == mockModel)
    }

    // MARK: - Community

    @Test
    func importCommunityAttributes() async throws {
        let mockModel = CommunityAttributesFactory.create()

        let store = DataStore<Storage.CommunityAttributes>()
        try await store.importModel(mockModel)

        let localCommunityAttributes = try #require(await store.first(where: \.uniqueID == mockModel.id))
        #expect(localCommunityAttributes == mockModel)
    }

    @Test
    func importCommunityCounts() async throws {
        let mockModel = CommunityCountsFactory.create()

        let store = DataStore<Storage.CommunityCounts>()
        try await store.importModel(mockModel)

        let localCommunityCounts = try #require(await store.first(where: \.communityID == mockModel.communityID))
        #expect(localCommunityCounts == mockModel)
    }

    @Test
    func importCommunity() async throws {
        let mockModel = CommunityFactory.create()

        let store = DataStore<Storage.Community>()
        try await store.importModel(mockModel)

        let localCommunity = try #require(await store.first(where: \.communityAttributes.uniqueID == mockModel.attributes.id))
        #expect(localCommunity == mockModel)
    }

    // MARK: - Posts

    @Test
    func importPostAttributes() async throws {
        let mockModel = PostAttributesFactory.create()

        let store = DataStore<Storage.PostAttributes>()
        try await store.importModel(mockModel)

        let localPostAttributes = try #require(await store.first(where: \.uniqueID == mockModel.id))
        #expect(localPostAttributes == mockModel)
    }

    @Test
    func importPostCounts() async throws {
        let mockModel = PostCountsFactory.create()

        let store = DataStore<Storage.PostCounts>()
        try await store.importModel(mockModel)

        let localPostCounts = try #require(await store.first(where: \.postID == mockModel.postID))
        #expect(localPostCounts == mockModel)
    }

    @Test
    func importPost() async throws {
        let mockModel = PostFactory.create()

        let store = DataStore<Storage.Post>()
        try await store.importModel(mockModel)

        let localPost = try #require(await store.first(where: \.postID == mockModel.attributes.id))
        #expect(localPost == mockModel)
    }

    @Test
    func importSiteAttributes() async throws {
        let mockModel = SiteAttributesFactory.create()

        let store = DataStore<Storage.SiteAttributes>()
        try await store.importModel(mockModel)

        let localSiteAttributes = try #require(await store.first(where: \.uniqueID == mockModel.id))
        #expect(localSiteAttributes.description == mockModel.description)
    }

}
