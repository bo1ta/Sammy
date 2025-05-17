public class CommunityBuilder {
    public var attributes: CommunityAttributes = CommunityDataBuilder().build()
    public var subscribed = "Subscribed"
    public var blocked = false
    public var counts: CommunityCounts = CommunityCountsBuilder().build()
    public var bannedFromCommunity = false

    public init() { }

    public func withCommunityData(_ builder: (CommunityDataBuilder) -> Void) -> Self {
        let communityDataBuilder = CommunityDataBuilder()
        builder(communityDataBuilder)
        self.attributes = communityDataBuilder.build()
        return self
    }

    public func withSubscribed(_ status: String) -> Self {
        self.subscribed = status
        return self
    }

    public func withBlocked(_ blocked: Bool) -> Self {
        self.blocked = blocked
        return self
    }

    public func withCountsData(_ builder: (CommunityCountsBuilder) -> Void) -> Self {
        let communityCountsBuilder = CommunityCountsBuilder()
        builder(communityCountsBuilder)
        self.counts = communityCountsBuilder.build()
        return self
    }

    public func build() -> Community {
        Community(
            attributes: attributes,
            subscribed: subscribed,
            blocked: blocked,
            counts: counts,
            bannedFromCommunity: bannedFromCommunity)
    }
}
