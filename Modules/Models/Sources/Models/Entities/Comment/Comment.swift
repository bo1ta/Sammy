import Foundation

// MARK: - Comment

public struct Comment: Decodable, Sendable, Identifiable {
    public let commentData: CommentData
    public let creator: Person
    public let postData: PostData
    public let communityData: CommunityData
    public let countsData: CommentCounts

    public var id: Int {
        commentData.id
    }

    enum CodingKeys: String, CodingKey {
        case commentData = "comment"
        case creator
        case postData = "post"
        case communityData = "community"
        case countsData = "counts"
    }

    public init(
        commentData: CommentData,
        creator: Person,
        postData: PostData,
        communityData: CommunityData,
        countsData: CommentCounts)
    {
        self.commentData = commentData
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
