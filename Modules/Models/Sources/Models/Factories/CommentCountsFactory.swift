public enum CommentCountsFactory: BaseFactory {
    public static func create(
        commentID: Int? = nil,
        score: Int = 10,
        upvotes: Int = 12,
        published: String = "2023-01-01T00:00:00Z",
        childCount: Int = 3)
        -> CommentCounts
    {
        CommentCounts(
            commentID: commentID ?? randomInt(),
            score: score,
            upvotes: upvotes,
            published: published,
            childCount: childCount)
    }

    public static var sample: CommentCounts {
        create()
    }

    public static func createList(
        count: Int,
        modify: ((inout CommentCounts, Int) -> Void)? = nil)
        -> [CommentCounts]
    {
        (1...count).map { index in
            var counts = create(
                commentID: index,
                score: index * 5,
                upvotes: index * 5 + 2,
                childCount: index % 5)
            modify?(&counts, index)
            return counts
        }
    }

    public static var popularComment: CommentCounts {
        create(score: 100, upvotes: 105, childCount: 25)
    }

    public static var controversialComment: CommentCounts {
        create(score: -5, upvotes: 20, childCount: 15)
    }
}
