import SwiftUI

// MARK: - AppTabs

enum AppTabs: Int {
    case home
    case communities
    case search

    var title: String {
        switch self {
        case .home:
            "Home"
        case .communities:
            "Communities"
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
        case .search:
            "magnifyingglass"
        }
    }
}

// MARK: - AppTabView

struct AppTabView: View {
    @SceneStorage("currentTab") var currentTab = AppTabs.home

    var body: some View {
        TabView(selection: $currentTab) {
            Tab(AppTabs.home.title, systemImage: AppTabs.home.systemImageName, value: .home) {
                PostsView()
            }

            Tab(AppTabs.search.title, systemImage: AppTabs.search.systemImageName, value: .search) {
                SearchView()
            }

            Tab(AppTabs.communities.title, systemImage: AppTabs.communities.systemImageName, value: .communities) {
                CommunitiesView()
            }
        }
    }
}
