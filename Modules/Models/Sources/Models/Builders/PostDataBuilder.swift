public class PostDataBuilder {
    public var id = 1
    public var name = "Sample Post"
    public var url: String? = "https://example.com/post/1"
    public var body: String? = "This is a sample post body"
    public var creatorId = 1
    public var communityId = 1
    public var published = "2023-01-01T00:00:00Z"

    public init() { }

    public func withId(_ id: Int) -> PostDataBuilder {
        self.id = id
        return self
    }

    public func withName(_ name: String) -> PostDataBuilder {
        self.name = name
        return self
    }

    public func withCreatorId(_ id: Int) -> PostDataBuilder {
        self.creatorId = id
        return self
    }

    public func build() -> PostAttributes {
        PostAttributes(
            id: id,
            name: name,
            url: url,
            body: body,
            creatorId: creatorId,
            communityId: communityId,
            published: published)
    }
}
