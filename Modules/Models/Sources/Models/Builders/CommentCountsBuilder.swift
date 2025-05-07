public class CommentCountsBuilder {
    public var commentID = 1
    public var score = 5
    public var upvotes = 5
    public var published = "2023-01-01T00:00:00Z"
    public var childCount = 3

    public init() { }

    public func withCommentID(_ id: Int) -> Self {
        self.commentID = id
        return self
    }

    public func withScore(_ score: Int) -> Self {
        self.score = score
        return self
    }

    public func withChildCount(_ childCount: Int) -> Self {
        self.childCount = childCount
        return self
    }

    public func build() -> CommentCounts {
        CommentCounts(
            commentID: commentID,
            score: score,
            upvotes: upvotes,
            published: published,
            childCount: childCount)
    }
}
