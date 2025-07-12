public struct LocalUserAttributes: Codable, Sendable {
  public var id: Int
  public var personID: Int
  public var email: String?
  public var showNSFW: Bool
  public var theme: String
  public var defaultSortType: PersonSortType
  public var defaultListingType: ListingType
  public var interfaceLanguage: String
  public var showAvatars: Bool

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
