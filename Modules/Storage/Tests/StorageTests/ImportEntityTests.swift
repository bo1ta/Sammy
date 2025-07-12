import Principle
import Testing

@testable import Models
@testable import Storage

@Suite(.serialized)
class ImportEntityTests {

  private let readOnlyStore: ReadOnlyStore
  private let writeOnlyStore: WriteOnlyStore

  init() {
    CoreDataStore.setOverride(InMemoryCoreDataStore())
    readOnlyStore = CoreDataStore.readOnlyStore()
    writeOnlyStore = CoreDataStore.writeOnlyStore()
  }

  deinit {
    CoreDataStore.setOverride(nil)
  }

  // MARK: - Person

  @Test
  func importPersonCounts() async throws {
    let mockModel = PersonCountsFactory.create()
    try await writeOnlyStore.synchronize(mockModel, ofType: PersonCountsEntity.self)

    let localCounts = try #require(await readOnlyStore.firstObject(
      ofType: PersonCountsEntity.self,
      predicate: \.personID == mockModel.personID))
    #expect(localCounts.postCount == mockModel.postCount)
  }

  @Test
  func importLocalUser() async throws {
    let mockModel = LocalUserFactory.create()
    try await writeOnlyStore.synchronize(mockModel, ofType: LocalUserEntity.self)

    let localUser = try #require(await readOnlyStore.firstObject(
      ofType: LocalUserEntity.self,
      predicate: \.localUserAttributes.uniqueID == mockModel.userAttributes.id))
    #expect(localUser.userAttributes.id == mockModel.userAttributes.id)
  }

  ///
  @Test
  func importLocalUserAttributes() async throws {
    let mockModel = LocalUserAttributesFactory.create()

    try await writeOnlyStore.synchronize(mockModel, ofType: LocalUserAttributesEntity.self)

    let localUser = try #require(await readOnlyStore.firstObject(
      ofType: LocalUserAttributesEntity.self,
      predicate: \.uniqueID == mockModel.id))
    #expect(localUser.defaultSortType == mockModel.defaultSortType)
  }

  @Test
  func importCommentAttributes() async throws {
    let mockModel = CommentAttributesFactory.create()

    try await writeOnlyStore.synchronize(mockModel, ofType: CommentAttributesEntity.self)

    let localCommentAttributes = try #require(await readOnlyStore.firstObject(
      ofType: CommentAttributesEntity.self,
      predicate: \.uniqueID == mockModel.id))
    #expect(localCommentAttributes == mockModel)
  }

  @Test
  func importCommentCounts() async throws {
    let mockModel = CommentCountsFactory.create()
    try await writeOnlyStore.synchronize(mockModel, ofType: CommentCountsEntity.self)

    let localCommentCounts = try #require(await readOnlyStore.firstObject(
      ofType: CommentCountsEntity.self,
      predicate: \.commentID == mockModel.commentID))
    #expect(localCommentCounts.published == mockModel.published)
  }

  @Test
  func importComment() async throws {
    let mockModel = CommentFactory.create()
    try await writeOnlyStore.synchronize(mockModel, ofType: CommentEntity.self)

    let localComment = try #require(await readOnlyStore.firstObject(
      ofType: CommentEntity.self,
      predicate: \.commentID == mockModel.commentAttributes.id))
    #expect(localComment == mockModel)
  }

  @Test
  func importCommunityAttributes() async throws {
    let mockModel = CommunityAttributesFactory.create()
    try await writeOnlyStore.synchronize(mockModel, ofType: CommunityAttributesEntity.self)

    let localCommunityAttributes = try #require(await readOnlyStore.firstObject(
      ofType: CommunityAttributesEntity.self,
      predicate: \.uniqueID == mockModel.id))
    #expect(localCommunityAttributes == mockModel)
  }

  @Test
  func importCommunityCounts() async throws {
    let mockModel = CommunityCountsFactory.create()
    try await writeOnlyStore.synchronize(mockModel, ofType: CommunityCountsEntity.self)

    let localCommunityCounts = try #require(await readOnlyStore.firstObject(
      ofType: CommunityCountsEntity.self,
      predicate: \.communityID == mockModel.communityID))
    #expect(localCommunityCounts == mockModel)
  }

  @Test
  func importCommunity() async throws {
    let mockModel = CommunityFactory.create()
    try await writeOnlyStore.synchronize(mockModel, ofType: CommunityEntity.self)

    let localCommunity = try #require(await readOnlyStore.firstObject(
      ofType: CommunityEntity.self,
      predicate: \.communityAttributes.uniqueID == mockModel.attributes.id))
    #expect(localCommunity == mockModel)
  }

  @Test
  func importPostAttributes() async throws {
    let mockModel = PostAttributesFactory.create()
    try await writeOnlyStore.synchronize(mockModel, ofType: PostAttributesEntity.self)

    let localPostAttributes = try #require(await readOnlyStore.firstObject(
      ofType: PostAttributesEntity.self,
      predicate: \.uniqueID == mockModel.id))
    #expect(localPostAttributes == mockModel)
  }

  ///
  @Test
  func importPostCounts() async throws {
    let mockModel = PostCountsFactory.create()
    try await writeOnlyStore.synchronize(mockModel, ofType: PostCountsEntity.self)

    let localPostCounts = try #require(await readOnlyStore.firstObject(
      ofType: PostCountsEntity.self,
      predicate: \.postID == mockModel.postID))
    #expect(localPostCounts == mockModel)
  }

  ///
  @Test
  func importPost() async throws {
    let mockModel = PostFactory.create()
    try await writeOnlyStore.synchronize(mockModel, ofType: PostEntity.self)

    let localPost = try #require(await readOnlyStore.firstObject(
      ofType: PostEntity.self,
      predicate: \.postAttributes.uniqueID == mockModel.attributes.id))
    #expect(localPost == mockModel)
  }

  @Test
  func importSiteAttributes() async throws {
    let mockModel = SiteAttributesFactory.create()
    try await writeOnlyStore.synchronize(mockModel, ofType: SiteAttributesEntity.self)

    let localSiteAttributes = try #require(await readOnlyStore.firstObject(
      ofType: SiteAttributesEntity.self,
      predicate: \.uniqueID == mockModel.id))
    #expect(localSiteAttributes.description == mockModel.description)
  }
}
