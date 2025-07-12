public enum CommentFactory: BaseFactory {
  public static func create(
    commentAttributes: CommentAttributes = CommentAttributesFactory.create(),
    creator: PersonAttributes = PersonAttributesFactory.create(),
    postData: PostAttributes = PostAttributesFactory.create(),
    communityAttributes: CommunityAttributes = CommunityAttributesFactory.create(),
    countsData: CommentCounts = CommentCountsFactory.create())
    -> Comment
  {
    Comment(
      commentAttributes: commentAttributes,
      creator: creator,
      postData: postData,
      communityAttributes: communityAttributes,
      countsData: countsData)
  }

  public static var sample: Comment {
    create()
  }

  public static var popularComment: Comment {
    create(
      commentAttributes: CommentAttributesFactory.create(content: "This comment got many upvotes!"),
      countsData: CommentCountsFactory.popularComment)
  }

  public static var distinguishedComment: Comment {
    create(
      commentAttributes: CommentAttributesFactory.create(
        content: "Official moderator comment", distinguished: true),
      creator: PersonAttributesFactory.moderator)
  }

  public static var threadStarter: Comment {
    create(
      commentAttributes: CommentAttributesFactory.create(
        content: "This started the discussion", path: "0.1"),
      countsData: CommentCountsFactory.create(childCount: 15))
  }

  public static func createList(
    count: Int,
    modify: ((inout Comment, Int) -> Void)? = nil)
    -> [Comment]
  {
    (1...count).map { index in
      var comment = create(
        commentAttributes: CommentAttributesFactory.create(
          id: randomInt(),
          content: "Comment number \(index)"),
        countsData: CommentCountsFactory.create(commentID: index))
      modify?(&comment, index)
      return comment
    }
  }

  public static func createThread(
    depth: Int,
    parentComment: Comment? = nil,
    currentLevel: Int = 1)
    -> [Comment]
  {
    guard currentLevel <= depth else { return [] }

    let parentPath = parentComment?.commentAttributes.path ?? "0"
    let parentId = parentComment?.commentAttributes.id ?? 0

    var comments = [Comment]()
    let repliesCount = Int.random(in: 1...3)

    /// swiftlint:disable:next identifier_name
    for index in 1...repliesCount {
      let replyId = parentId * 10 + index
      let path = "\(parentPath).\(replyId)"

      let reply = create(
        commentAttributes: CommentAttributesFactory.create(
          id: replyId,
          content: "Reply at level \(currentLevel), number \(index)",
          path: path),
        countsData: CommentCountsFactory.create(
          commentID: replyId,
          childCount: currentLevel == depth ? 0 : Int.random(in: 0...2)))

      comments.append(reply)

      if currentLevel < depth {
        comments += createThread(
          depth: depth,
          parentComment: reply,
          currentLevel: currentLevel + 1)
      }
    }

    return comments
  }
}
