enum ProfileTabs: Int, Identifiable, CaseIterable {
    case posts = 0
    case comments = 1
    case saved = 2

    var id: Int {
        rawValue
    }

    var title: String {
        switch self {
        case .posts:
            "Posts"
        case .comments:
            "Comments"
        case .saved:
            "Saved"
        }
    }
}
