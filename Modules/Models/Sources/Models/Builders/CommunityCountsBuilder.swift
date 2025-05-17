public class CommunityCountsBuilder {
    public var communityID = 1
    public var subscribers = 100
    public var posts = 50
    public var comments = 200
    public var published = "2023-01-01T00:00:00Z"
    public var usersActiveDay = 10
    public var usersActiveWeek = 50
    public var usersActiveMonth = 150
    public var usersActiveHalfYear = 300
    public var subscribersLocal = 80

    public init() { }

    /// Fluent modifier methods
    public func withCommunityID(_ id: Int) -> Self {
        self.communityID = id
        return self
    }

    public func withSubscribers(_ count: Int) -> Self {
        self.subscribers = count
        return self
    }

    // ... add similar methods for all properties

    public func build() -> CommunityCounts {
        CommunityCounts(
            communityID: communityID,
            subscribers: subscribers,
            posts: posts,
            comments: comments,
            published: published,
            usersActiveDay: usersActiveDay,
            usersActiveWeek: usersActiveWeek,
            usersActiveMonth: usersActiveMonth,
            usersActiveHalfYear: usersActiveHalfYear,
            subscribersLocal: subscribersLocal)
    }
}
