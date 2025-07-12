import Foundation

public struct CommentCounts: Decodable, Sendable, Identifiable {
  public let commentID: Int
  public let score: Int
  public let upvotes: Int
  public let published: String
  public let childCount: Int

  enum CodingKeys: String, CodingKey {
    case commentID = "comment_id"
    case score
    case upvotes
    case published
    case childCount = "child_count"
  }

  public var id: Int { commentID }

  public init(commentID: Int, score: Int, upvotes: Int, published: String, childCount: Int) {
    self.commentID = commentID
    self.score = score
    self.upvotes = upvotes
    self.published = published
    self.childCount = childCount
  }
}
