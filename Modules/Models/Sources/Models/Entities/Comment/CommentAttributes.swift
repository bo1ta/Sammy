import Foundation

public struct CommentAttributes: Decodable, Identifiable, Equatable, Sendable {
  public var id: Int
  public var creatorID: Int
  public var postID: Int
  public var content: String
  public var removed: Bool
  public var published: String
  public var updated: String?
  public var deleted: Bool
  public var local: Bool
  public var path: String
  public var distinguished: Bool
  public var languageID: Int

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
