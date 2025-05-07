public class PostCountsBuilder {
    public var postID = 1
    public var comments = 5
    public var score = 10
    public var upvotes = 15
    public var downvotes = 5
    public var published = "2023-01-01T00:00:00Z"
    public var newestCommentTime = "2023-01-01T12:00:00Z"

    public init() { }

    public func withPostID(_ postID: Int) -> PostCountsBuilder {
        self.postID = postID
        return self
    }

    public func withUpvotes(_ upvotes: Int) -> PostCountsBuilder {
        self.upvotes = upvotes
        return self
    }

    public func withDownvotes(_ downvotes: Int) -> PostCountsBuilder {
        self.downvotes = downvotes
        return self
    }

    public func build() -> PostCounts {
        PostCounts(
            postID: postID,
            comments: comments,
            score: score,
            upvotes: upvotes,
            downvotes: downvotes,
            published: published,
            newestCommentTime: newestCommentTime)
    }
}
