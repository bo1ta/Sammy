import Foundation

public struct CommentData: Decodable, Identifiable, Equatable, Sendable {
    public let id: Int
    public let creatorID: Int
    public let postID: Int
    public let content: String
    public let removed: Bool
    public let published: String
    public let updated: String?
    public let deleted: Bool
    public let local: Bool
    public let path: String
    public let distinguished: Bool
    public let languageID: Int

    enum CodingKeys: String, CodingKey {
        case id
        case creatorID = "creator_id"
        case postID = "post_id"
        case content
        case removed
        case published
        case updated
        case deleted
        case local
        case path
        case distinguished
        case languageID = "language_id"
    }

    public init(
        id: Int,
        creatorID: Int,
        postID: Int,
        content: String,
        removed: Bool,
        published: String,
        updated: String?,
        deleted: Bool,
        local: Bool,
        path: String,
        distinguished: Bool,
        languageID: Int)
    {
        self.id = id
        self.creatorID = creatorID
        self.postID = postID
        self.content = content
        self.removed = removed
        self.published = published
        self.updated = updated
        self.deleted = deleted
        self.local = local
        self.path = path
        self.distinguished = distinguished
        self.languageID = languageID
    }
}
