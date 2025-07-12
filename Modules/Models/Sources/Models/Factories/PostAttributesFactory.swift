public enum PostAttributesFactory: BaseFactory {
  public static func create(
    id: Int? = nil,
    name: String = "Sample Post",
    url: String? = "https://example.com/image.jpg",
    body: String? = "This is a sample post body text.",
    creatorId: Int = 1,
    communityId: Int = 1,
    published: String = "2023-01-01T00:00:00Z")
    -> PostAttributes
  {
    PostAttributes(
      id: id ?? randomInt(),
      name: name,
      url: url,
      body: body,
      creatorId: creatorId,
      communityId: communityId,
      published: published)
  }

  public static var sample: PostAttributes {
    create()
  }

  public static func createList(
    count: Int,
    modify: ((inout PostAttributes, Int) -> Void)? = nil)
    -> [PostAttributes]
  {
    (1...count).map { index in
      var post = create(
        id: index,
        name: "Post \(index)",
        creatorId: index % 5 + 1,
        communityId: index % 3 + 1)
      modify?(&post, index)
      return post
    }
  }
}
