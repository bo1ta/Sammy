public class CommentBuilder {
    public var commentData: CommentData = CommentDataBuilder().build()
    public var creator: Person = PersonBuilder().build()
    public var postData: PostData = PostDataBuilder().build()
    public var communityData: CommunityData = CommunityDataBuilder().build()
    public var countsData: CommentCounts = CommentCountsBuilder().build()

    public init() { }

    public func withCommentData(_ builder: (CommentDataBuilder) -> Void) -> Self {
        let commentDataBuilder = CommentDataBuilder()
        builder(commentDataBuilder)
        self.commentData = commentDataBuilder.build()
        return self
    }

    public func withCreator(_ builder: (PersonBuilder) -> Void) -> Self {
        let personBuilder = PersonBuilder()
        builder(personBuilder)
        self.creator = personBuilder.build()
        return self
    }

    public func build() -> Comment {
        Comment(
            commentData: commentData,
            creator: creator,
            postData: postData,
            communityData: communityData,
            countsData: countsData)
    }
}
