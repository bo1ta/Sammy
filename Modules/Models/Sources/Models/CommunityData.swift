import Foundation

public struct CommunityData: Codable, Identifiable, Sendable, Hashable {
    public var id: Int
    public var name: String
    public var title: String
    public var description: String?
    public var published: String
    public var updated: String?
    public var icon: String?
    public var banner: String?
    public var visibility: String

    public var bannerURL: URL? {
        guard let banner else {
            return nil
        }
        return URL(string: banner)
    }

    public var iconURL: URL? {
        guard let icon else {
            return nil
        }
        return URL(string: icon)
    }

    public init(
        id: Int,
        name: String,
        title: String,
        description: String? = nil,
        published: String,
        updated: String? = nil,
        icon: String? = nil,
        banner: String? = nil,
        visibility: String)
    {
        self.id = id
        self.name = name
        self.title = title
        self.description = description
        self.published = published
        self.updated = updated
        self.icon = icon
        self.banner = banner
        self.visibility = visibility
    }
}
