public enum PostFactory: BaseFactory {
    public static func create(
        postData: PostAttributes = PostAttributesFactory.create(),
        creator: PersonAttributes = PersonAttributesFactory.create(),
        postCounts: PostCounts = PostCountsFactory.create(),
        communityAttributes: CommunityAttributes = CommunityAttributesFactory.create())
        -> Post
    {
        Post(
            postData: postData,
            creatorData: creator,
            postCounts: postCounts,
            communityAttributes: communityAttributes)
    }

    public static var sample: Post {
        create()
    }

    public static var textPost: Post {
        create(
            postData: PostAttributesFactory.create(
                url: nil,
                body: "This is a text-only post"))
    }

    public static var linkPost: Post {
        create(
            postData: PostAttributesFactory.create(
                url: "https://example.com/interesting-article", body: nil))
    }

    public static var imagePost: Post {
        create(
            postData: PostAttributesFactory.create(
                url: "https://example.com/beautiful-image.jpg",
                body: "Check out this amazing photo!"))
    }

    public static var popularPost: Post {
        create(
            postCounts: PostCountsFactory.popularPost)
    }

    public static func createList(
        count: Int,
        modify: ((inout Post, Int) -> Void)? = nil)
        -> [Post]
    {
        (1...count).map { index in
            var post = create(
                postData: PostAttributesFactory.create(
                    name: "Post \(index)",
                    creatorId: index % 5 + 1),
                postCounts: PostCountsFactory.create(
                    postID: index,
                    comments: index * 3))
            modify?(&post, index)
            return post
        }
    }

    public static func createForCommunity(
        community: CommunityAttributes,
        count: Int,
        creator: PersonAttributes? = nil)
        -> [Post]
    {
        createList(count: count) { post, _ in
            post.postData.communityId = community.id
            post.communityAttributes = community
            if let creator {
                post.creator = creator
                post.postData.creatorId = creator.id
            }
        }
    }
}
