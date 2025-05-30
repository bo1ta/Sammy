public struct SiteResponse: Decodable {
    public let myUser: MyUserInfo

    enum CodingKeys: String, CodingKey {
        case myUser = "my_user"
    }

    public init(myUser: MyUserInfo) {
        self.myUser = myUser
    }
}
