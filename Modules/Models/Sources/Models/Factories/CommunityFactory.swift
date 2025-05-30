public enum CommunityFactory: BaseFactory {
    public static func create(
        attributes: CommunityAttributes = CommunityAttributesFactory.create(),
        subscribed: String = "Subscribed",
        blocked: Bool = false,
        counts: CommunityCounts = CommunityCountsFactory.create(),
        bannedFromCommunity: Bool = false)
        -> Community
    {
        Community(
            attributes: attributes,
            subscribed: subscribed,
            blocked: blocked,
            counts: counts,
            bannedFromCommunity: bannedFromCommunity)
    }

    public static var sample: Community {
        create()
    }

    public static var largeActiveCommunity: Community {
        create(
            attributes: CommunityAttributesFactory.create(
                name: "large_community",
                title: "Large Active Community"),
            counts: CommunityCountsFactory.largeCommunity)
    }

    public static var smallNicheCommunity: Community {
        create(
            attributes: CommunityAttributesFactory.create(
                name: "small_community",
                title: "Small Niche Community"),
            counts: CommunityCountsFactory.smallCommunity)
    }

    public static var publicCommunity: Community {
        create(
            attributes: CommunityAttributesFactory.create(
                visibility: "public"))
    }

    public static var privateCommunity: Community {
        create(
            attributes: CommunityAttributesFactory.create(
                visibility: "private"))
    }

    public static var restrictedCommunity: Community {
        create(
            attributes: CommunityAttributesFactory.create(
                visibility: "restricted"))
    }

    public static var blockedCommunity: Community {
        create(
            blocked: true)
    }

    public static func createList(
        count: Int,
        modify: ((inout Community, Int) -> Void)? = nil)
        -> [Community]
    {
        (1...count).map { index in
            var community = create(
                attributes: CommunityAttributesFactory.create(
                    id: index,
                    name: "community_\(index)",
                    title: "Community \(index)"),
                counts: CommunityCountsFactory.create(
                    communityID: index))
            modify?(&community, index)
            return community
        }
    }
}
