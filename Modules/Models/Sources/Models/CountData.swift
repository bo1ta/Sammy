import Foundation

public struct PostCountsData: Decodable, Sendable, Hashable {
    public var postID: Int
    public var comments: Int
    public var score: Int
    public var upvotes: Int
    public var downvotes: Int
    public var published: String
    public var newestCommentTime: String

    enum CodingKeys: String, CodingKey {
        case postID = "post_id"
        case comments
        case score
        case upvotes
        case downvotes
        case published
        case newestCommentTime = "newest_comment_time"
    }

    public init(
        postID: Int,
        comments: Int,
        score: Int,
        upvotes: Int,
        downvotes: Int,
        published: String,
        newestCommentTime: String)
    {
        self.postID = postID
        self.comments = comments
        self.score = score
        self.upvotes = upvotes
        self.downvotes = downvotes
        self.published = published
        self.newestCommentTime = newestCommentTime
    }
}
