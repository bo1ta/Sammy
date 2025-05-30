import Foundation

// MARK: - Community

public struct Community: Decodable, Sendable, Identifiable, Hashable {
    public let attributes: CommunityAttributes
    public let subscribed: String
    public let blocked: Bool
    public let counts: CommunityCounts
    public let bannedFromCommunity: Bool

    enum CodingKeys: String, CodingKey {
        case attributes = "community"
        case subscribed
        case blocked
        case counts
        case bannedFromCommunity = "banned_from_community"
    }

    public var id: Int {
        attributes.id
    }

    public init(
        attributes: CommunityAttributes,
        subscribed: String,
        blocked: Bool,
        counts: CommunityCounts,
        bannedFromCommunity: Bool)
    {
        self.attributes = attributes
        self.subscribed = subscribed
        self.blocked = blocked
        self.counts = counts
        self.bannedFromCommunity = bannedFromCommunity
    }
}

// MARK: Equatable

extension Community: Equatable {
    public static func ==(lhs: Community, rhs: Community) -> Bool {
        lhs.attributes.id == rhs.attributes.id
    }
}
