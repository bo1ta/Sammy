public enum CommentAttributesFactory: BaseFactory {
    public static func create(
        id: Int? = nil,
        creatorID: Int = 1,
        postID: Int = 1,
        content: String = "Sample comment content",
        removed: Bool = false,
        published: String = "2023-01-01T00:00:00Z",
        updated: String? = nil,
        deleted: Bool = false,
        local: Bool = true,
        path: String = "0.1",
        distinguished: Bool = false,
        languageID: Int = 1)
        -> CommentAttributes
    {
        CommentAttributes(
            id: id ?? randomInt(),
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

    public static func createList(count: Int, modify: ((inout CommentAttributes, Int) -> Void)? = nil) -> [CommentAttributes] {
        (1...count).map { index in
            var comment = create(id: index)
            modify?(&comment, index)
            return comment
        }
    }
}
