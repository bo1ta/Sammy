enum CommunityTabs: Int, CaseIterable, Identifiable {
    case myCommunities = 0
    case discover = 1

    var id: Int {
        rawValue
    }

    var title: String {
        switch self {
        case .myCommunities:
            "My Communities"
        case .discover:
            "Discover"
        }
    }
}

