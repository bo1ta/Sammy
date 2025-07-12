import Foundation

// MARK: - Post

public struct Post: Codable, Sendable {
  public var attributes: PostAttributes
  public var creator: PersonAttributes
  public var postCounts: PostCounts
  public var communityAttributes: CommunityAttributes
  public var saved: Bool
  public var read: Bool
  public var hidden: Bool
  public var myVote: Int?
  public var unreadComments: Int

  public var voteType: VoteType {
    guard let myVote, let voteType = VoteType(rawValue: myVote) else { return .none }
    return voteType
  }

  enum CodingKeys: String, CodingKey {
    case attributes = "post"
    case creator
    case postCounts = "counts"
    case communityAttributes = "community"
    case saved
    case read
    case hidden
    case myVote = "my_vote"
    case unreadComments = "unread_comments"
  }

  public init(
    postData: PostAttributes,
    creatorData: PersonAttributes,
    postCounts: PostCounts,
    communityAttributes: CommunityAttributes,
    saved: Bool,
    read: Bool,
    hidden: Bool,
    myVote: Int?,
    unreadComments: Int)
  {
    self.attributes = postData
    self.creator = creatorData
    self.postCounts = postCounts
    self.communityAttributes = communityAttributes
    self.saved = saved
    self.read = read
    self.hidden = hidden
    self.myVote = myVote
    self.unreadComments = unreadComments
  }
}

// MARK: Hashable

extension Post: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(attributes.id)
    hasher.combine(creator.id)
  }
}

// MARK: Equatable

extension Post: Equatable {
  public static func ==(_ lhs: Post, rhs: Post) -> Bool {
    lhs.attributes.id == rhs.attributes.id
  }
}

// MARK: Identifiable

extension Post: Identifiable {
  public var id: Int { attributes.id }
}
