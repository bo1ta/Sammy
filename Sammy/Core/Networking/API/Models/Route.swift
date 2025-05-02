// MARK: - Route

public enum Route {
    case post(APIRoute.PostRoute)

    public var path: String {
        switch self {
        case .post(let postRoute):
            "/post/\(postRoute.path)"
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
}
