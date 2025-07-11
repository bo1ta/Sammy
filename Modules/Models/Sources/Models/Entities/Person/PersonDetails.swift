import Foundation

// MARK: - PersonDetails

public struct PersonDetails: Decodable, Sendable {
    public let personProfile: PersonProfile
    public let siteAttributes: SiteAttributes
    public let comments: [Comment]
    public let posts: [Post]
    public let moderates: [Moderates]

    enum CodingKeys: String, CodingKey {
        case personProfile = "person_view"
        case siteAttributes = "site"
        case comments
        case posts
        case moderates
    }

    public init(
        personProfile: PersonProfile,
        siteAttributes: SiteAttributes,
        comments: [Comment],
        posts: [Post],
        moderates: [Moderates])
    {
        self.personProfile = personProfile
        self.siteAttributes = siteAttributes
        self.comments = comments
        self.posts = posts
        self.moderates = moderates
    }
}

// MARK: PersonDetails.Moderates

extension PersonDetails {
    public struct Moderates: Decodable, Sendable {
        public let communities: [Community]
        public let moderator: PersonAttributes

        public init(communities: [Community], moderator: PersonAttributes) {
            self.communities = communities
            self.moderator = moderator
        }
    }
}
