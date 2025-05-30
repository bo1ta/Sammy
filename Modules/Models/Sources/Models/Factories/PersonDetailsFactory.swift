public enum PersonDetailsFactory {
    public static func create(
        personProfile: PersonProfile = PersonProfileFactory.create(),
        siteAttributes: SiteAttributes = SiteAttributesFactory.create(),
        comments: [Comment] = [CommentFactory.create()],
        posts: [Post] = [PostFactory.create()],
        moderates: [PersonDetails.Moderates] = [ModeratesFactory.create()])
        -> PersonDetails
    {
        PersonDetails(
            personProfile: personProfile,
            siteAttributes: siteAttributes,
            comments: comments,
            posts: posts,
            moderates: moderates)
    }

    public static var sample: PersonDetails {
        create()
    }

    public static var adminDetails: PersonDetails {
        create(
            personProfile: PersonProfileFactory.adminProfile,
            moderates: [
                ModeratesFactory.create(
                    communities: CommunityFactory.createList(count: 3),
                    moderator: PersonAttributesFactory.admin),
            ])
    }

    public static func createList(
        count: Int,
        modify: ((inout PersonDetails, Int) -> Void)? = nil)
        -> [PersonDetails]
    {
        (1...count).map { index in
            var details = create(
                personProfile: PersonProfileFactory.create(
                    person: PersonAttributesFactory.create(id: index)))
            modify?(&details, index)
            return details
        }
    }
}
