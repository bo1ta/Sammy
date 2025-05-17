public class CommunityDataBuilder {
    public var id = 1
    public var name = "samplecommunity"
    public var title = "Sample Community"
    public var description: String? = "A sample community for testing"
    public var published = "2023-01-01T00:00:00Z"
    public var updated: String?
    public var icon: String? = "https://example.com/icon.jpg"
    public var banner: String? = "https://example.com/banner.jpg"
    public var visibility = "public"

    public init() { }

    public func withId(_ id: Int) -> CommunityDataBuilder {
        self.id = id
        return self
    }

    public func withName(_ name: String) -> CommunityDataBuilder {
        self.name = name
        return self
    }

    public func build() -> CommunityAttributes {
        CommunityAttributes(
            id: id,
            name: name,
            title: title,
            description: description,
            published: published,
            updated: updated,
            icon: icon,
            banner: banner,
            visibility: visibility)
    }
}
