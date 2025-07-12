import Foundation
import Models

// MARK: - HomeDestinations

enum HomeDestinations: NavigationDestination {
  var tab: AppTabs { .home }

  case postDetail(Post)
}

// MARK: - CommunitiesDestination

enum CommunitiesDestination: NavigationDestination {
  var tab: AppTabs { .communities }
}

// MARK: - ProfileDestination

enum ProfileDestination: NavigationDestination {
  var tab: AppTabs { .profile }
}

// MARK: - SearchDestination

enum SearchDestination: NavigationDestination {
  var tab: AppTabs { .search }
}
