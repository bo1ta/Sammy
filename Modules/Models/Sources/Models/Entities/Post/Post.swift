import Foundation

// MARK: - Post

public struct Post: Decodable, Sendable {
    public var postData: PostAttributes
    public var creator: PersonAttributes
    public var postCounts: PostCounts
    public var communityAttributes: CommunityAttributes

    enum CodingKeys: String, CodingKey {
        case postData = "post"
        case creator
        case postCounts = "counts"
        case communityAttributes = "community"
    }

    public init(
        postData: PostAttributes,
        creatorData: PersonAttributes,
        postCounts: PostCounts,
        communityAttributes: CommunityAttributes)
    {
        self.postData = postData
        self.creator = creatorData
        self.postCounts = postCounts
        self.communityAttributes = communityAttributes
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
