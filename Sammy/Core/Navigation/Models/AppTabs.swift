enum AppTabs: Int {
  case home
  case communities
  case profile
  case search

  var title: String {
    switch self {
    case .home:
      "Home"
    case .communities:
      "Communities"
    case .profile:
      "Profile"
    case .search:
      "Search"
    }
  }

  var systemImageName: String {
    switch self {
    case .home:
      "house"
    case .communities:
      "person.2"
    case .profile:
      "person.crop.circle"
    case .search:
      "magnifyingglass"
    }
  }
}
