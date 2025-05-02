// MARK: - Route

public enum Route {
    case post(APIRoute.PostRoute)
    case community(APIRoute.CommunityRoute)

    public var path: String {
        switch self {
        case .post(let postRoute):
            "/post/\(postRoute.path)"
        case .community(let route):
            "/community/\(route.path)"
        }
    }
}

// MARK: - APIRoute

public enum APIRoute {
    public enum PostRoute {
        case list

        var path: String {
            switch self {
            case .list:
                "list"
            }
        }
    }

    public enum CommunityRoute {
        case list

        var path: String {
            switch self {
            case .list:
                "list"
            }
        }
    }
}
