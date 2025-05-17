// MARK: - MyUserInfo

public struct MyUserInfo: Decodable {
    public let localUserView: LocalUser
    public let follows: [Follows]

    enum CodingKeys: String, CodingKey {
        case localUserView = "local_user_view"
        case follows
    }

    public init(localUserView: LocalUser, follows: [Follows]) {
        self.localUserView = localUserView
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

public struct LocalUser: Decodable {
    public let userAttributes: LocalUserAttributes
    public let personAttributes: PersonAttributes

    enum CodingKeys: String, CodingKey {
        case userAttributes = "local_user"
        case personAttributes = "person"
    }

    public init(userAttributes: LocalUserAttributes, personAttributes: PersonAttributes) {
        self.userAttributes = userAttributes
        self.personAttributes = personAttributes
    }
}
