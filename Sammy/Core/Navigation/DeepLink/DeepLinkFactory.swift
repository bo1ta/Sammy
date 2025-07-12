import Foundation
import Models

enum DeepLinkFactory {
  private static func make(
    host: String,
    path: String? = nil,
    queryItems: [URLQueryItem]? = nil)
    -> URL?
  {
    var components = URLComponents()
    components.scheme = "sammy"
    components.host = host
    components.queryItems = queryItems
    components.path = path ?? ""

    return components.url
  }

  static func postDetailDeepLink(postID: Post.ID) -> URL? {
    let path = "/\(postID)"
    return make(host: PostDetailDeepLink.host, path: path)
  }
}
