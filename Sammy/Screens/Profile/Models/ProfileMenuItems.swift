enum ProfileMenuItems: Int, Identifiable, CaseIterable {
    case myAccount = 0
    case saved = 1
    case history = 2
    case settings = 3
    case helpAndSupport = 4
    case logOut = 5

    var id: Int {
        rawValue
    }

    var title: String {
        switch self {
        case .myAccount:
            "My Account"
        case .saved:
            "Saved"
        case .history:
            "History"
        case .settings:
            "Settings"
        case .helpAndSupport:
            "Help & Support"
        case .logOut:
            "Log Out"
        }
    }

    var systemImageName: String {
        switch self {
        case .myAccount:
            "person.circle"
        case .saved:
            "square.and.arrow.down"
        case .history:
            "clock"
        case .settings:
            "gear"
        case .helpAndSupport:
            "questionmark.circle"
        case .logOut:
            "rectangle.portrait.and.arrow.right"
        }
    }
}
