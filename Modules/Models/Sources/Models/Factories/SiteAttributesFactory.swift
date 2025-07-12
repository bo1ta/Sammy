public enum SiteAttributesFactory: BaseFactory {
  public static func create(
    id: Int? = nil,
    name: String = "Sample Site",
    sidebar: String? = "Welcome to our sample site",
    published: String = "2023-01-01T00:00:00Z",
    updated: String? = nil,
    icon: String? = "https://example.com/icon.png",
    banner: String? = "https://example.com/banner.jpg",
    description: String? = "This is a sample site description",
    actorID: String = "https://example.com/actor/1",
    lastRefreshedAt: String = "2023-01-01T12:00:00Z",
    inboxUrl: String = "https://example.com/inbox/1",
    contentWarning: String? = nil,
    publicKey: String = "sample-public-key-123",
    instanceID: Int = 1)
    -> SiteAttributes
  {
    SiteAttributes(
      id: id ?? randomInt(),
      name: name,
      sidebar: sidebar,
      published: published,
      updated: updated,
      icon: icon,
      banner: banner,
      description: description,
      actorID: actorID,
      lastRefreshedAt: lastRefreshedAt,
      inboxUrl: inboxUrl,
      contentWarning: contentWarning,
      publicKey: publicKey,
      instanceID: instanceID)
  }

  public static func createList(
    count: Int,
    modify: ((inout SiteAttributes, Int) -> Void)? = nil)
    -> [SiteAttributes]
  {
    (1...count).map { index in
      var site = create(
        id: index,
        name: "Site \(index)",
        actorID: "https://example.com/actor/\(index)",
        instanceID: index % 3 + 1 // Vary instance IDs between 1-3
      )
      modify?(&site, index)
      return site
    }
  }

  public static var sample: SiteAttributes {
    create()
  }

  public static var samples: [SiteAttributes] {
    [
      create(id: 1, name: "Main Site", description: "Primary community site"),
      create(
        id: 2,
        name: "Backup Site",
        updated: "2023-02-01T00:00:00Z",
        icon: nil,
        instanceID: 2),
      create(id: 3, name: "Test Site", lastRefreshedAt: "2023-01-15T08:30:00Z", contentWarning: "Experimental features"),
    ]
  }

  public static var minimalSite: SiteAttributes {
    create(
      sidebar: nil,
      updated: nil,
      icon: nil,
      banner: nil,
      description: nil,
      contentWarning: nil)
  }

  public static var fullFeaturedSite: SiteAttributes {
    create(
      sidebar: "Detailed sidebar with rules and information",
      updated: "2023-06-01T14:30:00Z",
      description: "Complete description of our community",
      contentWarning: "For mature audiences only")
  }
}
