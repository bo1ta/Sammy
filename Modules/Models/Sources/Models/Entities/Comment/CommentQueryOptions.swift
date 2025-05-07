import Foundation

public enum CommentQueryOption: Sendable {
    case listingType(ListingType)
    case sortType(CommentSortType)
    case maxDepth(Int)
    case page(Int)
    case limit(Int)
    case communityID(Int)
    case communityName(String)
    case parentID(Int)
    case savedOnly(Bool)
    case likedOnly(Bool)
    case dislikedOnly(Bool)

    public var queryItem: URLQueryItem {
        switch self {
        case .listingType(let type):
            URLQueryItem(name: "type_", value: type.rawValue)
        case .sortType(let type):
            URLQueryItem(name: "sort", value: type.rawValue)
        case .maxDepth(let depth):
            URLQueryItem(name: "max_depth", value: String(depth))
        case .page(let page):
            URLQueryItem(name: "page", value: String(page))
        case .limit(let limit):
            URLQueryItem(name: "limit", value: String(limit))
        case .communityID(let id):
            URLQueryItem(name: "community_id", value: String(id))
        case .communityName(let name):
            URLQueryItem(name: "community_name", value: name)
        case .parentID(let id):
            URLQueryItem(name: "parent_id", value: String(id))
        case .savedOnly(let savedOnly):
            URLQueryItem(name: "saved_only", value: String(savedOnly))
        case .likedOnly(let likedOnly):
            URLQueryItem(name: "liked_only", value: String(likedOnly))
        case .dislikedOnly(let dislikedOnly):
            URLQueryItem(name: "disliked_only", value: String(dislikedOnly))
        }
    }
}
