public class PersonBuilder {
    public var id = 1
    public var name = "testuser"
    public var displayName: String? = "Test User"
    public var avatar: String? = "https://example.com/avatar.jpg"
    public var banned = false
    public var published = "2023-01-01T00:00:00Z"
    public var updated: String? = nil
    public var actorID = "https://example.com/u/testuser"
    public var bio: String? = "Just a test user"
    public var local = true
    public var banner: String? = nil
    public var deleted = false
    public var matrixUserID: String? = nil
    public var botAccount = false
    public var banExpires: String? = nil
    public var instanceID = 1

    public init() { }

    public func withId(_ id: Int) -> PersonBuilder {
        self.id = id
        return self
    }

    public func withName(_ name: String) -> PersonBuilder {
        self.name = name
        return self
    }

    public func build() -> Person {
        Person(
            id: id,
            name: name,
            displayName: displayName,
            avatar: avatar,
            banned: banned,
            published: published,
            updated: updated,
            actorID: actorID,
            bio: bio,
            local: local,
            banner: banner,
            deleted: deleted,
            matrixUserID: matrixUserID,
            botAccount: botAccount,
            banExpires: banExpires,
            instanceID: instanceID)
    }
}
