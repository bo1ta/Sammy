public enum ListingType: String, Encodable, Sendable {
    case all = "All"
    case local = "Local"
    case subscribed = "Subscribed"
    case moderatorView = "ModeratorView"
}
