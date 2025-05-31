import Foundation

// MARK: - PersonAttributes

public struct PersonAttributes: Codable, Equatable, Identifiable, Sendable {
    public let id: Int
    public let name: String
    public let displayName: String?
    public let avatar: String?
    public let banned: Bool
    public let published: String
    public let updated: String?
    public let actorID: String
    public let bio: String?
    public let local: Bool
    public let banner: String?
    public let deleted: Bool
    public let matrixUserID: String?
    public let botAccount: Bool
    public let banExpires: String?
    public let instanceID: Int

    public var userTitle: String {
        "u/\(name)"
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case displayName = "display_name"
        case avatar
        case banned
        case published
        case updated
        case actorID = "actor_id"
        case bio
        case local
        case banner
        case deleted
        case matrixUserID = "matrix_user_id"
        case botAccount = "bot_account"
        case banExpires = "ban_expires"
        case instanceID = "instance_id"
    }

    public init(
        id: Int,
        name: String,
        displayName: String?,
        avatar: String?,
        banned: Bool,
        published: String,
        updated: String?,
        actorID: String,
        bio: String?,
        local: Bool,
        banner: String?,
        deleted: Bool,
        matrixUserID: String?,
        botAccount: Bool,
        banExpires: String?,
        instanceID: Int)
    {
        self.id = id
        self.name = name
        self.displayName = displayName
        self.avatar = avatar
        self.banned = banned
        self.published = published
        self.updated = updated
        self.actorID = actorID
        self.bio = bio
        self.local = local
        self.banner = banner
        self.deleted = deleted
        self.matrixUserID = matrixUserID
        self.botAccount = botAccount
        self.banExpires = banExpires
        self.instanceID = instanceID
    }
}
