import Foundation

public struct PersonDetails: Decodable {
    public let personProfile: PersonProfile
    public let siteAttributes: SiteAttributes
    public let comments: [Comment]
    public let posts: [Post]
    public let moderates: [Moderates]
}

extension PersonDetails {
    public struct Moderates: Decodable {
        public let communities: [Community]
        public let moderator: PersonAttributes

        public init(communities: [Community], moderator: PersonAttributes) {
            self.communities = communities
            self.moderator = moderator
        }
    }
}
