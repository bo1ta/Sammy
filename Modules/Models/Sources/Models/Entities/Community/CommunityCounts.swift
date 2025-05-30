import Foundation

// MARK: - CommunityCounts

public struct CommunityCounts: Decodable, Hashable, Identifiable, Sendable {
    public let communityID: Int
    public let subscribers: Int
    public let posts: Int
    public let comments: Int
    public let published: String
    public let usersActiveDay: Int
    public let usersActiveWeek: Int
    public let usersActiveMonth: Int
    public let usersActiveHalfYear: Int
    public let subscribersLocal: Int

    public var id: Int { communityID }

    enum CodingKeys: String, CodingKey {
        case communityID = "community_id"
        case subscribers
        case posts
        case comments
        case published
        case usersActiveDay = "users_active_day"
        case usersActiveWeek = "users_active_week"
        case usersActiveMonth = "users_active_month"
        case usersActiveHalfYear = "users_active_half_year"
        case subscribersLocal = "subscribers_local"
    }

    public init(
        communityID: Int,
        subscribers: Int,
        posts: Int,
        comments: Int,
        published: String,
        usersActiveDay: Int,
        usersActiveWeek: Int,
        usersActiveMonth: Int,
        usersActiveHalfYear: Int,
        subscribersLocal: Int)
    {
        self.communityID = communityID
        self.subscribers = subscribers
        self.posts = posts
        self.comments = comments
        self.published = published
        self.usersActiveDay = usersActiveDay
        self.usersActiveWeek = usersActiveWeek
        self.usersActiveMonth = usersActiveMonth
        self.usersActiveHalfYear = usersActiveHalfYear
        self.subscribersLocal = subscribersLocal
    }
}

// MARK: Equatable

extension CommunityCounts: Equatable {
    public static func ==(_ lhs: CommunityCounts, rhs: CommunityCounts) -> Bool {
        lhs.communityID == rhs.communityID
    }
}
