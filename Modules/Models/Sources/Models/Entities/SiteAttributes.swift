import Foundation

public struct SiteAttributes: Decodable, Sendable {
  public let id: Int
  public let name: String
  public let sidebar: String?
  public let published: String
  public let updated: String?
  public let icon: String?
  public let banner: String?
  public let description: String?
  public let actorID: String
  public let lastRefreshedAt: String
  public let inboxUrl: String
  public let contentWarning: String?
  public let publicKey: String
  public let instanceID: Int

  enum CodingKeys: String, CodingKey {
    case id
    case name
    case sidebar
    case published
    case updated
    case icon
    case banner
    case description
    case actorID = "actor_id"
    case lastRefreshedAt = "last_refreshed_at"
    case inboxUrl = "inbox_url"
    case publicKey = "public_key"
    case instanceID = "instance_id"
    case contentWarning = "content_warning"
  }

  public init(
    id: Int,
    name: String,
    sidebar: String? = nil,
    published: String,
    updated: String? = nil,
    icon: String? = nil,
    banner: String? = nil,
    description: String? = nil,
    actorID: String,
    lastRefreshedAt: String,
    inboxUrl: String,
    contentWarning: String? = nil,
    publicKey: String,
    instanceID: Int)
  {
    self.id = id
    self.name = name
    self.sidebar = sidebar
    self.published = published
    self.updated = updated
    self.icon = icon
    self.banner = banner
    self.description = description
    self.actorID = actorID
    self.lastRefreshedAt = lastRefreshedAt
    self.inboxUrl = inboxUrl
    self.contentWarning = contentWarning
    self.publicKey = publicKey
    self.instanceID = instanceID
  }
}
