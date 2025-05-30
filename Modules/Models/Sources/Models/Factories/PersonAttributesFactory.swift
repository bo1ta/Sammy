public enum PersonAttributesFactory {
    public static func create(
        id: Int = 1,
        name: String = "sample_user",
        displayName: String? = "Sample User",
        avatar: String? = "https://example.com/avatar.jpg",
        banned: Bool = false,
        published: String = "2023-01-01T00:00:00Z",
        updated: String? = nil,
        actorID: String = "https://example.com/user/1",
        bio: String? = "Sample bio text",
        local: Bool = true,
        banner: String? = "https://example.com/banner.jpg",
        deleted: Bool = false,
        matrixUserID: String? = nil,
        botAccount: Bool = false,
        banExpires: String? = nil,
        instanceID: Int = 1)
        -> PersonAttributes
    {
        PersonAttributes(
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

    public static func createList(
        count: Int,
        modify: ((inout PersonAttributes, Int) -> Void)? = nil)
        -> [PersonAttributes]
    {
        (1...count).map { index in
            var person = create(
                id: index,
                name: "user_\(index)",
                displayName: "User \(index)",
                actorID: "https://example.com/user/\(index)")
            modify?(&person, index)
            return person
        }
    }

    public static var sample: PersonAttributes {
        create()
    }

    public static var samples: [PersonAttributes] {
        [
            create(id: 1, name: "admin", displayName: "Admin User"),
            create(id: 2, name: "moderator", displayName: "Community Moderator"),
            create(id: 3, name: "bot", displayName: "Service Bot", botAccount: true),
        ]
    }

    public static var admin: PersonAttributes {
        create(displayName: "Administrator")
    }

    public static var moderator: PersonAttributes {
        create(displayName: "Moderator")
    }

    public static var bot: PersonAttributes {
        create(displayName: "Bot Account", botAccount: true)
    }

    public static var bannedUser: PersonAttributes {
        create(displayName: "Banned User", banned: true, banExpires: "2024-01-01T00:00:00Z")
    }
}
