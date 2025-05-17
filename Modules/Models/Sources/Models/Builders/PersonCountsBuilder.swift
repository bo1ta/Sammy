public class PersonCountsBuilder {
    public var personID = 1
    public var postCount = 10
    public var commentCount = 10

    public init() { }

    public func withPersonID(_ id: Int) -> Self {
        self.personID = id
        return self
    }

    public func withPostCount(_ postCount: Int) -> Self {
        self.postCount = postCount
        return self
    }

    public func withCommentCount(_ commentCount: Int) -> Self {
        self.commentCount = commentCount
        return self
    }

    public func build() -> PersonCounts {
        PersonCounts(personID: personID, postCount: postCount, commentCount: commentCount)
    }
}
