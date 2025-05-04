import Foundation

// MARK: - Community

public struct Community: Decodable, Sendable, Identifiable, Hashable {
    public let communityData: CommunityData
    public let subscribed: String
    public let blocked: Bool
    public let countsData: CommunityCountsData
    public let bannedFromCommunity: Bool

    enum CodingKeys: String, CodingKey {
        case communityData = "community"
        case subscribed
        case blocked
        case countsData = "counts"
        case bannedFromCommunity = "banned_from_community"
    }

    public var id: Int {
        communityData.id
    }

    public init(
        communityData: CommunityData,
        subscribed: String,
        blocked: Bool,
        countsData: CommunityCountsData,
        bannedFromCommunity: Bool)
    {
        self.communityData = communityData
        self.subscribed = subscribed
        self.blocked = blocked
        self.countsData = countsData
        self.bannedFromCommunity = bannedFromCommunity
    }
}

// MARK: Equatable

extension Community: Equatable {
    public static func ==(lhs: Community, rhs: Community) -> Bool {
        lhs.communityData.id == rhs.communityData.id
    }
}
