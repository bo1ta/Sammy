import Foundation

public enum ListingType: String, Codable, Sendable {
  case all = "All"
  case local = "Local"
  case subscribed = "Subscribed"
  case moderatorView = "ModeratorView"
}
