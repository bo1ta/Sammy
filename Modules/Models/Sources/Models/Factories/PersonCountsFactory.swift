public enum PersonCountsFactory: BaseFactory {
  public static func create(
    personID: Int? = nil,
    postCount: Int = 10,
    commentCount: Int = 25)
    -> PersonCounts
  {
    PersonCounts(
      personID: personID ?? randomInt(),
      postCount: postCount,
      commentCount: commentCount)
  }

  public static var sample: PersonCounts {
    create()
  }

  public static func createList(
    count: Int,
    modify: ((inout PersonCounts, Int) -> Void)? = nil)
    -> [PersonCounts]
  {
    (1...count).map { index in
      var counts = create(
        personID: index,
        postCount: index * 5,
        commentCount: index * 10)
      modify?(&counts, index)
      return counts
    }
  }
}
