public struct LocalUserAttributes: Codable {
    public let id: Int
    public let personID: Int
    public let email: String?
    public let showNSFW: Bool
    public let theme: String
    public let defaultSortType: PersonSortType
    public let defaultListingType: ListingType
    public let interfaceLanguage: String
    public let showAvatars: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case personID = "person_id"
        case email
        case showNSFW = "show_nsfw"
        case theme
        case defaultSortType = "default_sort_type"
        case defaultListingType = "default_listing_type"
        case interfaceLanguage = "interface_language"
        case showAvatars = "show_avatars"
    }

    public init(
        id: Int,
        personID: Int,
        email: String?,
        showNSFW: Bool,
        theme: String,
        defaultSortType: PersonSortType,
        defaultListingType: ListingType,
        interfaceLanguage: String,
        showAvatars: Bool)
    {
        self.id = id
        self.personID = personID
        self.email = email
        self.showNSFW = showNSFW
        self.theme = theme
        self.defaultSortType = defaultSortType
        self.defaultListingType = defaultListingType
        self.interfaceLanguage = interfaceLanguage
        self.showAvatars = showAvatars
    }
}
