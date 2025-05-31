enum ProfileActions: Int, CaseIterable, Identifiable {
    case profile = 0
    case edit = 1

    var id: Int {
        rawValue
    }

    var title: String {
        switch self {
        case .profile:
            "Profile"
        case .edit:
            "Edit"
        }
    }
}
