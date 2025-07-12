public enum PersonProfileFactory {
  public static func create(
    person: PersonAttributes = PersonAttributesFactory.create(),
    personCounts: PersonCounts = PersonCountsFactory.create(),
    isAdmin: Bool = false)
    -> PersonProfile
  {
    PersonProfile(
      person: person,
      personCounts: personCounts,
      isAdmin: isAdmin)
  }

  public static var sample: PersonProfile {
    create()
  }

  public static var adminProfile: PersonProfile {
    create(
      person: PersonAttributesFactory.admin,
      isAdmin: true)
  }

  public static var activeUserProfile: PersonProfile {
    create(
      personCounts: PersonCountsFactory.create(postCount: 50, commentCount: 200))
  }
}
