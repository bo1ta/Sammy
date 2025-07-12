import Foundation

public struct PersonCounts: Decodable, Sendable {
  public let personID: Int
  public let postCount: Int
  public let commentCount: Int

  enum CodingKeys: String, CodingKey {
    case personID = "person_id"
    case postCount = "post_count"
    case commentCount = "comment_count"
  }

  public init(personID: Int, postCount: Int, commentCount: Int) {
    self.personID = personID
    self.postCount = postCount
    self.commentCount = commentCount
  }
}
