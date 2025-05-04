public class CommentDataBuilder {
    public var id = 1
    public var creatorID = 1
    public var postID = 1
    public var content = "Sample comment"
    public var removed = false
    public var published = "2023-01-01T00:00:00Z"
    public var updated: String? = nil
    public var deleted = false
    public var local = true
    public var path = "0.1"
    public var distinguished = false
    public var languageID = 1

    public init() { }

    public func withId(_ id: Int) -> Self {
        self.id = id
        return self
    }

    public func withContent(_ text: String) -> Self {
        self.content = text
        return self
    }

    public func withPath(_ path: String) -> Self {
        self.path = path
        return self
    }

    public func build() -> CommentData {
        CommentData(
            id: id,
            creatorID: creatorID,
            postID: postID,
            content: content,
            removed: removed,
            published: published,
            updated: updated,
            deleted: deleted,
            local: local,
            path: path,
            distinguished: distinguished,
            languageID: languageID)
    }
}
