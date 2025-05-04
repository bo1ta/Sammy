import Foundation

public struct CommentQueryOptions: Sendable {
    public var type: ListingType?
    public var sort: CommentSortType?
    public var maxDepth: Int?
    public var page: Int?
    public var limit: Int?
    public var communityID: Int?
    public var communityName: String?
    public var parentID: Int?
    public var savedOnly: Bool?
    public var likedOnly: Bool?
    public var dislikedOnly: Bool?

    public init(
        type: ListingType? = nil,
        sort: CommentSortType? = nil,
        maxDepth: Int? = nil,
        page: Int? = nil,
        limit: Int? = nil,
        communityID: Int? = nil,
        communityName: String? = nil,
        parentID: Int? = nil,
        savedOnly: Bool? = nil,
        likedOnly: Bool? = nil,
        dislikedOnly: Bool? = nil)
    {
        self.type = type
        self.sort = sort
        self.maxDepth = maxDepth
        self.page = page
        self.limit = limit
        self.communityID = communityID
        self.communityName = communityName
        self.parentID = parentID
        self.savedOnly = savedOnly
        self.likedOnly = likedOnly
        self.dislikedOnly = dislikedOnly
    }

    public func createQueryItems() -> [URLQueryItem] {
        var parameters: [String: Any] = [:]

        if let type {
            parameters["type_"] = type.rawValue
        }

        if let sort {
            parameters["sort"] = sort.rawValue
        }

        if let maxDepth {
            parameters["max_depth"] = maxDepth
        }

        if let page {
            parameters["page"] = page
        }

        if let limit {
            parameters["limit"] = limit
        }

        if let communityID {
            parameters["community_id"] = communityID
        }

        if let communityName {
            parameters["community_name"] = communityName
        }

        if let parentID {
            parameters["parent_id"] = parentID
        }

        if let savedOnly {
            parameters["saved_only"] = savedOnly
        }

        if let likedOnly {
            parameters["liked_only"] = likedOnly
        }

        if let dislikedOnly {
            parameters["disliked_only"] = dislikedOnly
        }

        return parameters.map { element in
            URLQueryItem(name: element.key, value: "\(element.value)")
        }
    }
}
