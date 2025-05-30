public enum ModeratesFactory {
    public static func create(
        communities: [Community] = [CommunityFactory.create()],
        moderator: PersonAttributes = PersonAttributesFactory.create())
        -> PersonDetails.Moderates
    {
        PersonDetails.Moderates(
            communities: communities,
            moderator: moderator)
    }

    public static var sample: PersonDetails.Moderates {
        create()
    }
}
