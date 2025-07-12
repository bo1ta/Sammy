import Foundation

public enum PersonDetailsQueryOption {
  case personID(Int)
  case username(String)
  case sort(PersonSortType)
  case page(Int)
  case limit(Int)
  case communityID(Int)
  case savedOnly(Bool)

  public var queryItem: URLQueryItem {
    switch self {
    case .personID(let id):
      URLQueryItem(name: "person_id", value: String(id))
    case .username(let username):
      URLQueryItem(name: "username", value: username)
    case .sort(let sortType):
      URLQueryItem(name: "sort", value: sortType.rawValue)
    case .page(let page):
      URLQueryItem(name: "page", value: String(page))
    case .limit(let limit):
      URLQueryItem(name: "limit", value: String(limit))
    case .communityID(let id):
      URLQueryItem(name: "community_id", value: String(id))
    case .savedOnly(let savedOnly):
      URLQueryItem(name: "saved_only", value: String(savedOnly))
    }
  }
}
