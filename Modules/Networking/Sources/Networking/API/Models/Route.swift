// MARK: - Route

public enum Route {
    case post(APIRoute.PostRoute)
    case community(APIRoute.CommunityRoute)
    case user(APIRoute.UserRoute)
    case comment(APIRoute.CommentRoute)

    public var path: String {
        switch self {
        case .post(let postRoute):
            "/post\(postRoute.path)"
        case .community(let route):
            "/community\(route.path)"
        case .user(let route):
            "/user\(route.path)"
        case .comment(let route):
            "/comment\(route.path)"
        }
    }
}

// MARK: - APIRoute

public enum APIRoute {
    public enum PostRoute {
        case list
        case index
        case markAsRead
        case like

        var path: String {
            switch self {
            case .index:
                ""
            case .list:
                "/list"
            case .markAsRead:
                "/mark_as_read"
            case .like:
                "/like"
            }
        }
    }

    public enum CommunityRoute {
        case list
        case index

        var path: String {
            switch self {
            case .list:
                "/list"
            case .index:
                ""
            }
        }
    }

    public enum UserRoute {
        case register

        var path: String {
            switch self {
            case .register:
                "/register"
            }
        }
    }

    public enum CommentRoute {
        case list
        case like

        var path: String {
            switch self {
            case .list:
                "/list"
            case .like:
                "/like"
            }
        }
    }
}
