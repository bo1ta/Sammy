public enum LocalUserFactory: BaseFactory {
    public static func create(
        userAttributes: LocalUserAttributes = LocalUserAttributesFactory.create(),
        personAttributes: PersonAttributes = PersonAttributesFactory.create())
        -> LocalUser
    {
        // Ensure personID matches
        var userAttrs = userAttributes
        userAttrs.personID = personAttributes.id

        return LocalUser(
            userAttributes: userAttrs,
            personAttributes: personAttributes)
    }

    public static var sample: LocalUser {
        create()
    }

    public static var adminUser: LocalUser {
        create(
            personAttributes: PersonAttributesFactory.admin)
    }

    public static var moderatorUser: LocalUser {
        create(
            personAttributes: PersonAttributesFactory.moderator)
    }

    public static func createList(
        count: Int,
        modify: ((inout LocalUser, Int) -> Void)? = nil)
        -> [LocalUser]
    {
        (1...count).map { index in
            var user = create(
                userAttributes: LocalUserAttributesFactory.create(
                    email: "user\(index)@example.com"),
                personAttributes: PersonAttributesFactory.create(
                    id: index,
                    name: "user\(index)"))
            modify?(&user, index)
            return user
        }
    }
}
