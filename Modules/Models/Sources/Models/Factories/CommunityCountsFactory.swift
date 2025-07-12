public enum CommunityCountsFactory: BaseFactory {
  public static func create(
    communityID: Int? = nil,
    subscribers: Int = 100,
    posts: Int = 50,
    comments: Int = 200,
    published: String = "2023-01-01T00:00:00Z",
    usersActiveDay: Int = 10,
    usersActiveWeek: Int = 30,
    usersActiveMonth: Int = 100,
    usersActiveHalfYear: Int = 250,
    subscribersLocal: Int = 80)
    -> CommunityCounts
  {
    CommunityCounts(
      communityID: communityID ?? randomInt(),
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

  public static var sample: CommunityCounts {
    create()
  }

  public static var largeCommunity: CommunityCounts {
    create(
      subscribers: 5000,
      posts: 2500,
      comments: 10000,
      usersActiveDay: 500,
      usersActiveWeek: 1500,
      usersActiveMonth: 4000,
      usersActiveHalfYear: 4500,
      subscribersLocal: 3000)
  }

  public static var smallCommunity: CommunityCounts {
    create(
      subscribers: 20,
      posts: 5,
      comments: 30,
      usersActiveDay: 2,
      usersActiveWeek: 5,
      usersActiveMonth: 15,
      usersActiveHalfYear: 18,
      subscribersLocal: 15)
  }

  public static func createList(
    count: Int,
    modify: ((inout CommunityCounts, Int) -> Void)? = nil)
    -> [CommunityCounts]
  {
    (1...count).map { index in
      var counts = create(
        communityID: index,
        subscribers: index * 100,
        posts: index * 50,
        comments: index * 200)
      modify?(&counts, index)
      return counts
    }
  }
}
