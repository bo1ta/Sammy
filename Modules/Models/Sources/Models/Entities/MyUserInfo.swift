// MARK: - MyUserInfo

public struct MyUserInfo: Decodable {
    public let localUserView: LocalUserView
    public let follows: [Follows]

    enum CodingKeys: String, CodingKey {
        case localUserView = "local_user_view"
        case follows
    }

    public init(localUserView: LocalUserView, follows: [Follows]) {
        self.localUserView = localUserView
        self.follows = follows
    }
}

extension MyUserInfo {
    public struct Follows: Decodable {
        let community: Community
        let follower: PersonAttributes
    }

    public struct LocalUserView: Decodable {
        public let localUser: LocalUser
        public let person: PersonAttributes

        enum CodingKeys: String, CodingKey {
            case localUser = "local_user"
            case person
        }

        public init(localUser: LocalUser, person: PersonAttributes) {
            self.localUser = localUser
            self.person = person
        }
    }
}
