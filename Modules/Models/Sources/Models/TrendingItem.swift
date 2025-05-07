public struct TrendingItem: Identifiable {
    public let id: Int
    public let rank: Int
    public let title: String
    public let postCount: String

    public init(id: Int, rank: Int, title: String, postCount: String) {
           self.id = id
           self.rank = rank
           self.title = title
           self.postCount = postCount
       }
}
