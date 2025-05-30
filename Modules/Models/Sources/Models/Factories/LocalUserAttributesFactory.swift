public enum LocalUserAttributesFactory: BaseFactory {
    public static func create(
        id: Int? = nil,
        personID: Int? = nil,
        email: String? = "user@example.com",
        showNSFW: Bool = false,
        theme: String = "dark",
        defaultSortType: PersonSortType = .hot,
        defaultListingType: ListingType = .all,
        interfaceLanguage: String = "en",
        showAvatars: Bool = true)
        -> LocalUserAttributes
    {
        LocalUserAttributes(
            id: id ?? randomInt(),
            personID: personID ?? randomInt(),
            email: email,
            showNSFW: showNSFW,
            theme: theme,
            defaultSortType: defaultSortType,
            defaultListingType: defaultListingType,
            interfaceLanguage: interfaceLanguage,
            showAvatars: showAvatars)
    }

    public static var sample: LocalUserAttributes {
        create()
    }

    public static var nsfwUser: LocalUserAttributes {
        create(showNSFW: true)
    }

    public static var lightThemeUser: LocalUserAttributes {
        create(theme: "light")
    }

    public static func createList(
        count: Int,
        modify: ((inout LocalUserAttributes, Int) -> Void)? = nil)
        -> [LocalUserAttributes]
    {
        (1...count).map { index in
            var user = create(
                email: "user\(index)@example.com",
                interfaceLanguage: index % 2 == 0 ? "en" : "fr")
            modify?(&user, index)
            return user
        }
    }
}
