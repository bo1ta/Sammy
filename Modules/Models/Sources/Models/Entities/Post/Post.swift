import Foundation

// MARK: - Post

public struct Post: Decodable, Sendable {
    public var postData: PostData
    public var creator: Person
    public var postCounts: PostCounts
    public var communityData: CommunityData

    enum CodingKeys: String, CodingKey {
        case postData = "post"
        case creator
        case postCounts = "counts"
        case communityData = "community"
    }

    public init(postData: PostData, creatorData: Person, postCounts: PostCounts, communityData: CommunityData) {
        self.postData = postData
        self.creator = creatorData
        self.postCounts = postCounts
        self.communityData = communityData
    }
}

// MARK: Hashable

extension Post: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(postData.id)
        hasher.combine(creator.id)
    }
}

// MARK: Equatable

extension Post: Equatable {
    public static func ==(_ lhs: Post, rhs: Post) -> Bool {
        lhs.postData.id == rhs.postData.id
    }
}

// MARK: Identifiable

extension Post: Identifiable {
    public var id: Int { postData.id }
}
