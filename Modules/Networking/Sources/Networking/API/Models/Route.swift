// MARK: - Route

public enum Route {
  case post(APIRoute.PostRoute)
  case community(APIRoute.CommunityRoute)
  case user(APIRoute.UserRoute)
  case comment(APIRoute.CommentRoute)
  case site(APIRoute.SiteRoute)

  public var path: String {
    switch self {
    case .post(let route):
      route.fullPath
    case .community(let route):
      route.fullPath
    case .user(let route):
      route.fullPath
    case .comment(let route):
      route.fullPath
    case .site(let route):
      route.fullPath
    }
  }
}

// MARK: - RouteType

protocol RouteType {
  static var basePath: String { get }
  var path: String { get }
}

extension RouteType {
  var fullPath: String {
    "/" + Self.basePath + "/" + path
  }
}

// MARK: - APIRoute

public enum APIRoute {
  public enum PostRoute: RouteType {
    static var basePath: String { "post" }

    case list
    case index
    case markAsRead
    case like

    var path: String {
      switch self {
      case .index:
        ""
      case .list:
        "list"
      case .markAsRead:
        "mark_as_read"
      case .like:
        "like"
      }
    }
  }

  public enum CommunityRoute: RouteType {
    static var basePath: String { "community" }

    case list
    case index

    var path: String {
      switch self {
      case .list:
        "list"
      case .index:
        ""
      }
    }
  }

  public enum UserRoute: RouteType {
    static var basePath: String { "user" }

    case register
    case login
    case index
    case getCaptcha
    case verifyEmail
    case listLogins

    var path: String {
      switch self {
      case .index:
        ""
      case .register:
        "register"
      case .login:
        "login"
      case .getCaptcha:
        "get_captcha"
      case .verifyEmail:
        "verify_email"
      case .listLogins:
        "list_logins"
      }
    }
  }

  public enum CommentRoute: RouteType {
    static var basePath: String { "comment" }

    case list
    case like

    var path: String {
      switch self {
      case .list:
        "list"
      case .like:
        "like"
      }
    }
  }

  public enum SiteRoute: RouteType {
    static var basePath: String { "site" }

    case index

    var path: String {
      switch self {
      case .index:
        ""
      }
    }
  }
}
