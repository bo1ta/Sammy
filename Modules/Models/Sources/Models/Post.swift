import Foundation

// MARK: - Post

public struct Post: Decodable, Sendable {
    public var postData: PostData
    public var creatorData: CreatorData
    public var countsData: PostCountsData
    public var communityData: CommunityData

    enum CodingKeys: String, CodingKey {
        case postData = "post"
        case creatorData = "creator"
        case countsData = "counts"
        case communityData = "community"
    }

    public init(postData: PostData, creatorData: CreatorData, countsData: PostCountsData, communityData: CommunityData) {
        self.postData = postData
        self.creatorData = creatorData
        self.countsData = countsData
        self.communityData = communityData
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
