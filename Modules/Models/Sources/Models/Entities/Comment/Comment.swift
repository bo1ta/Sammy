import Foundation

// MARK: - Comment

public struct Comment: Decodable, Sendable, Identifiable {
    public let commentAttributes: CommentAttributes
    public let creator: PersonAttributes
    public let postData: PostAttributes
    public let communityAttributes: CommunityAttributes
    public let countsData: CommentCounts

    public var id: Int {
        commentAttributes.id
    }

    enum CodingKeys: String, CodingKey {
        case commentAttributes = "comment"
        case creator
        case postData = "post"
        case communityAttributes = "community"
        case countsData = "counts"
    }

    public init(
        commentAttributes: CommentAttributes,
        creator: PersonAttributes,
        postData: PostAttributes,
        communityAttributes: CommunityAttributes,
        countsData: CommentCounts)
    {
        self.commentAttributes = commentAttributes
        self.creator = creator
        self.postData = postData
        self.communityAttributes = communityAttributes
        self.countsData = countsData
    }
}

// MARK: Equatable

extension Comment: Equatable {
    public static func ==(_ lhs: Comment, rhs: Comment) -> Bool {
        lhs.id == rhs.id
    }
}
