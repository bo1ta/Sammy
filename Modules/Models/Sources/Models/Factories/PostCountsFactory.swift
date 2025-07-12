public enum PostCountsFactory: BaseFactory {
  public static func create(
    postID: Int? = nil,
    comments: Int = 5,
    score: Int = 10,
    upvotes: Int = 12,
    downvotes: Int = 2,
    published: String = "2023-01-01T00:00:00Z",
    newestCommentTime: String = "2023-01-01T12:30:00Z")
    -> PostCounts
  {
    PostCounts(
      postID: postID ?? randomInt(),
      comments: comments,
      score: score,
      upvotes: upvotes,
      downvotes: downvotes,
      published: published,
      newestCommentTime: newestCommentTime)
  }

  public static var sample: PostCounts {
    create()
  }

  public static var popularPost: PostCounts {
    create(
      comments: 50,
      score: 150,
      upvotes: 160,
      downvotes: 10)
  }

  public static var controversialPost: PostCounts {
    create(
      comments: 75,
      score: 5,
      upvotes: 40,
      downvotes: 35)
  }

  public static func createList(
    count: Int,
    modify: ((inout PostCounts, Int) -> Void)? = nil)
    -> [PostCounts]
  {
    (1...count).map { index in
      var counts = create(
        comments: index * 3,
        score: index * 10,
        upvotes: index * 10 + 2,
        downvotes: index * 2)
      modify?(&counts, index)
      return counts
    }
  }
}
