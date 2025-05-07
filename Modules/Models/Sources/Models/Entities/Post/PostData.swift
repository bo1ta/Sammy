import Foundation

public struct PostData: Codable, Identifiable, Hashable, Sendable {
    public let id: Int
    public let name: String
    public let url: String?
    public let body: String?
    public let creatorId: Int
    public let communityId: Int
    public let published: String

    public var imageURL: URL? {
        guard let url, isImageURL(url) else {
            return nil
        }
        return URL(string: url)
    }

    private func isImageURL(_ url: String) -> Bool {
        url.contains("png") || url.contains("jpeg") || url.contains("jpg")
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name, url, body
        case creatorId = "creator_id"
        case communityId = "community_id"
        case published
    }

    public init(id: Int, name: String, url: String?, body: String?, creatorId: Int, communityId: Int, published: String) {
        self.id = id
        self.name = name
        self.url = url
        self.body = body
        self.creatorId = creatorId
        self.communityId = communityId
        self.published = published
    }
}
