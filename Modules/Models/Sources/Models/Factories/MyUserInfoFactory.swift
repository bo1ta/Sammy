public enum MyUserInfoFactory: BaseFactory {
  public static func create(
    localUserView: LocalUser = LocalUserFactory.create(),
    follows: [MyUserInfo.Follows] = [FollowsFactory.create()])
    -> MyUserInfo
  {
    MyUserInfo(
      localUserView: localUserView,
      follows: follows)
  }

  public static var sample: MyUserInfo {
    create()
  }

  public static var userWithManyFollows: MyUserInfo {
    create(
      follows: FollowsFactory.createList(count: 10))
  }

  public static var adminUserInfo: MyUserInfo {
    create(
      localUserView: LocalUserFactory.adminUser)
  }

  public static func createList(
    count: Int,
    modify: ((inout MyUserInfo, Int) -> Void)? = nil)
    -> [MyUserInfo]
  {
    (1...count).map { index in
      var userInfo = create(
        localUserView: LocalUserFactory.create(
          personAttributes: PersonAttributesFactory.create(id: index)))
      modify?(&userInfo, index)
      return userInfo
    }
  }

  public static func createForUser(
    person: PersonAttributes,
    follows: [Community] = [])
    -> MyUserInfo
  {
    let userFollows = follows.map {
      FollowsFactory.create(community: $0, follower: person)
    }

    return create(
      localUserView: LocalUserFactory.create(
        userAttributes: LocalUserAttributesFactory.create(personID: person.id),
        personAttributes: person),
      follows: userFollows)
  }
}
