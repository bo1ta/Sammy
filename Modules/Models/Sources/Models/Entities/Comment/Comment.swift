import Foundation

// MARK: - Comment

public struct Comment: Decodable, Sendable, Identifiable {
    public let commentAttributes: CommentAttributes
    public let creator: Person
    public let postData: PostData
    public let communityData: CommunityData
    public let countsData: CommentCounts

    public var id: Int {
        commentAttributes.id
    }

    enum CodingKeys: String, CodingKey {
        case commentAttributes = "comment"
        case creator
        case postData = "post"
        case communityData = "community"
        case countsData = "counts"
    }

    public init(
        commentAttributes: CommentAttributes,
        creator: Person,
        postData: PostData,
        communityData: CommunityData,
        countsData: CommentCounts)
    {
        self.commentAttributes = commentAttributes
        self.creator = creator
        self.postData = postData
        self.communityData = communityData
        self.countsData = countsData
    }
}

// MARK: Equatable

extension Comment: Equatable {
    public static func ==(_ lhs: Comment, rhs: Comment) -> Bool {
        lhs.id == rhs.id
    }
}
