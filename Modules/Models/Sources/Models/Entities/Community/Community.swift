import Foundation

// MARK: - Community

public struct Community: Decodable, Sendable, Identifiable, Hashable {
    public let communityData: CommunityData
    public let subscribed: String
    public let blocked: Bool
    public let counts: CommunityCounts
    public let bannedFromCommunity: Bool

    enum CodingKeys: String, CodingKey {
        case communityData = "community"
        case subscribed
        case blocked
        case counts
        case bannedFromCommunity = "banned_from_community"
    }

    public var id: Int {
        communityData.id
    }

    public init(
        communityData: CommunityData,
        subscribed: String,
        blocked: Bool,
        counts: CommunityCounts,
        bannedFromCommunity: Bool)
    {
        self.communityData = communityData
        self.subscribed = subscribed
        self.blocked = blocked
        self.counts = counts
        self.bannedFromCommunity = bannedFromCommunity
    }
}

// MARK: Equatable

extension Community: Equatable {
    public static func ==(lhs: Community, rhs: Community) -> Bool {
        lhs.communityData.id == rhs.communityData.id
    }
}
