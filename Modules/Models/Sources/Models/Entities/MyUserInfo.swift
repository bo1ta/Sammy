// MARK: - MyUserInfo

public struct MyUserInfo: Decodable {
    public let localUser: LocalUser
    public let follows: [Follows]

    enum CodingKeys: String, CodingKey {
        case localUser = "local_user_view"
        case follows
    }

    public init(localUserView: LocalUser, follows: [Follows]) {
        self.localUser = localUserView
        self.follows = follows
    }
}

// MARK: MyUserInfo.Follows

extension MyUserInfo {
    public struct Follows: Decodable {
        let community: Community
        let follower: PersonAttributes
    }

}

// MARK: - LocalUser

public struct LocalUser: Codable, Identifiable {
    public let userAttributes: LocalUserAttributes
    public let personAttributes: PersonAttributes

    public var id: Int {
        userAttributes.id
    }

    public var personID: Int {
        personAttributes.id
    }

    enum CodingKeys: String, CodingKey {
        case userAttributes = "local_user"
        case personAttributes = "person"
    }

    public init(userAttributes: LocalUserAttributes, personAttributes: PersonAttributes) {
        self.userAttributes = userAttributes
        self.personAttributes = personAttributes
    }
}
