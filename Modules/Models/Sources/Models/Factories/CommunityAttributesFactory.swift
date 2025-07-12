public enum CommunityAttributesFactory: BaseFactory {
  public static func create(
    id: Int? = nil,
    name: String = "sample_community",
    title: String = "Sample Community",
    description: String? = "This is a sample community description",
    published: String = "2023-01-01T00:00:00Z",
    updated: String? = nil,
    icon: String? = "https://example.com/icon.png",
    banner: String? = "https://example.com/banner.jpg",
    visibility: String = "public")
    -> CommunityAttributes
  {
    CommunityAttributes(
      id: id ?? randomInt(),
      name: name,
      title: title,
      description: description,
      published: published,
      updated: updated,
      icon: icon,
      banner: banner,
      visibility: visibility)
  }

  public static func createList(
    count: Int,
    modify: ((inout CommunityAttributes, Int) -> Void)? = nil)
    -> [CommunityAttributes]
  {
    (1...count).map { index in
      var community = create(
        id: index,
        name: "community_\(index)",
        title: "Community \(index)")
      modify?(&community, index)
      return community
    }
  }

  public static var sample: CommunityAttributes {
    create()
  }

  public static var samples: [CommunityAttributes] {
    [
      create(id: 1, name: "tech", title: "Technology", visibility: "public"),
      create(id: 2, name: "science", title: "Science", icon: "https://example.com/science.png", visibility: "restricted"),
      create(
        id: 3,
        name: "arts",
        title: "Arts & Culture",
        updated: "2023-02-01T00:00:00Z",
        banner: "https://example.com/arts_banner.jpg",
        visibility: "private"),
    ]
  }

  public static var publicCommunity: CommunityAttributes {
    create(visibility: "public")
  }

  public static var privateCommunity: CommunityAttributes {
    create(visibility: "private")
  }

  public static var restrictedCommunity: CommunityAttributes {
    create(visibility: "restricted")
  }
}
