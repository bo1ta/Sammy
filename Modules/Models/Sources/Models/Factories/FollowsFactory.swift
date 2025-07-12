public enum FollowsFactory {
  public static func create(
    community: Community = CommunityFactory.create(),
    follower: PersonAttributes = PersonAttributesFactory.create())
    -> MyUserInfo.Follows
  {
    MyUserInfo.Follows(
      community: community,
      follower: follower)
  }

  public static var sample: MyUserInfo.Follows {
    create()
  }

  public static func createList(
    count: Int,
    modify: ((inout MyUserInfo.Follows, Int) -> Void)? = nil)
    -> [MyUserInfo.Follows]
  {
    (1...count).map { index in
      var follow = create(
        community: CommunityFactory.create(
          attributes: CommunityAttributesFactory.create(id: index)))
      modify?(&follow, index)
      return follow
    }
  }
}
