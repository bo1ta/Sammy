import Foundation

// MARK: - Post

struct Post: Decodable {
    var postData: PostData
    var creatorData: CreatorData
    var countsData: CountsData
    var communityData: CommunityData

    enum CodingKeys: String, CodingKey {
        case postData = "post"
        case creatorData = "creator"
        case countsData = "counts"
        case communityData = "community"
    }
}

// MARK: DecodableModel

extension Post: DecodableModel { }

// MARK: Equatable

extension Post: Equatable {
    static func ==(_ lhs: Post, rhs: Post) -> Bool {
        lhs.postData.id == rhs.postData.id
    }
}

// MARK: Identifiable

extension Post: Identifiable {
    var id: Int { postData.id }
}

extension Post {

    // MARK: - PostData

    struct PostData: Codable, Identifiable, Hashable {
        let id: Int
        let name: String
        let url: String?
        let body: String?
        let creatorId: Int
        let communityId: Int
        let published: String

        var imageURL: URL? {
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
    }

    // MARK: - CountsData

    struct CountsData: Decodable {
        var postID: Int
        var comments: Int
        var score: Int
        var upvotes: Int
        var downvotes: Int
        var published: String
        var newestCommentTime: String

        enum CodingKeys: String, CodingKey {
            case postID = "post_id"
            case comments
            case score
            case upvotes
            case downvotes
            case published
            case newestCommentTime = "newest_comment_time"
        }
    }

    // MARK: - CreatorData

    struct CreatorData: Codable, Identifiable {
        var id: Int
        var name: String
        var banned: Bool
        var actorID: String
        var instanceID: Int
        var isLocal: Bool

        enum CodingKeys: String, CodingKey {
            case id
            case name
            case banned
            case actorID = "actor_id"
            case instanceID = "instance_id"
            case isLocal = "local"
        }
    }

    // MARK: - CommunityData

    struct CommunityData: Codable, Identifiable {
        var id: Int
        var name: String
        var title: String
        var description: String
        var published: String
        var updated: String
        var icon: String?
        var banner: String?
        var visibility: String

        var bannerURL: URL? {
            guard let banner else {
                return nil
            }
            return URL(string: banner)
        }

        var iconURL: URL? {
            guard let icon else {
                return nil
            }
            return URL(string: icon)
        }
    }
}
