public class PostBuilder {
    public var postData: PostData = PostDataBuilder().build()
    public var creator: Person = PersonBuilder().build()
    public var postCounts: PostCounts = PostCountsBuilder().build()
    public var communityData: CommunityData = CommunityDataBuilder().build()

    public init() { }

    public func withPostData(_ builder: (PostDataBuilder) -> Void) -> PostBuilder {
        let postDataBuilder = PostDataBuilder()
        builder(postDataBuilder)
        self.postData = postDataBuilder.build()
        return self
    }

    public func withCreator(_ builder: (PersonBuilder) -> Void) -> PostBuilder {
        let personBuilder = PersonBuilder()
        builder(personBuilder)
        self.creator = personBuilder.build()
        return self
    }

    public func withPostCounts(_ builder: (PostCountsBuilder) -> Void) -> PostBuilder {
        let postCountsBuilder = PostCountsBuilder()
        builder(postCountsBuilder)
        self.postCounts = postCountsBuilder.build()
        return self
    }

    public func withCommunityData(_ builder: (CommunityDataBuilder) -> Void) -> PostBuilder {
        let communityDataBuilder = CommunityDataBuilder()
        builder(communityDataBuilder)
        self.communityData = communityDataBuilder.build()
        return self
    }

    public func build() -> Post {
        Post(
            postData: postData,
            creatorData: creator,
            postCounts: postCounts,
            communityData: communityData)
    }
}
