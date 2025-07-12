import Foundation
import Models

enum DeepLinkFactory {
  private static func make(
    host: String,
    queryItems: [URLQueryItem]? = nil)
    -> URL?
  {
    var components = URLComponents()
    components.scheme = "sammy"
    components.host = host
    components.queryItems = queryItems

    return components.url
  }

  static func postDetailDeepLink(postID: Post.ID) -> URL? {
    let queryItem = URLQueryItem(name: "id", value: String(postID))
    return make(host: PostDetailDeepLink.host, queryItems: [queryItem])
  }
}
