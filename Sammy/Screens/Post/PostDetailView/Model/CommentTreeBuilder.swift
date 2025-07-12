import Models

/// A utility for building hierarchial comment trees from flat comment arrays.
///
/// This builder transforms a flat list of comments with path-based relationships
/// into a nested tree structure where each node contains its child comments.
///
enum CommentTreeBuilder {

  /// Builds a hierarchical tree of comments from a flat array.
  ///
  /// - Parameter comments: An array of `Comment` objects to organize into a tree structure
  /// - Returns: An array of root `CommentNode` objects with nested child comments
  ///
  /// Example:
  /// ```
  /// let comments = [comment1, comment2, comment3] // where comment2 is a reply to comment1
  /// let commentTree = CommentTreeBuilder.buildTree(from: comments)
  /// // commentTree[0].children will contain comment2
  /// ```
  ///
  static func buildTree(from comments: [Comment]) -> [CommentNode] {
    let (commentDict, pathToCommentMap) = createInitialNodes(from: comments)

    var rootNodes = [CommentNode]()
    var mutableDict = commentDict

    for comment in comments {
      let pathComponents = comment.commentAttributes.path.components(separatedBy: ".")

      if isRootComment(pathComponents: pathComponents) {
        if let node = mutableDict[comment.commentAttributes.id] {
          rootNodes.append(node)
        }
      } else {
        linkChildToParent(
          comment: comment,
          pathComponents: pathComponents,
          mutableDict: &mutableDict,
          pathToCommentMap: pathToCommentMap)
      }
    }

    rootNodes = rootNodes.compactMap { mutableDict[$0.id] }
    return sortTree(nodes: rootNodes)
  }

  // MARK: - Private Helpers

  /// Creates initial node structures and path mappings from comments.
  ///
  /// - Parameter comments: Array of comments to process
  /// - Returns: A tuple containing:
  ///   - nodes: Dictionary mapping comment IDs to `CommentNode` objects
  ///   - pathMap: Dictionary mapping path strings to comment IDs
  ///
  /// This initial pass:
  /// 1. Creates all `CommentNode` objects without children
  /// 2. Calculates each comment's depth in the tree
  /// 3. Builds a path-to-ID lookup dictionary
  ///
  private static func createInitialNodes(from comments: [Comment])
    -> (nodes: [Int: CommentNode], pathMap: [String: Int])
  {
    var commentDict = [Int: CommentNode]()
    var pathToCommentMap = [String: Int]()

    for comment in comments {
      let depth = comment.commentAttributes.path.components(separatedBy: ".").count - 1
      let node = CommentNode(
        comment: comment,
        children: [],
        depth: depth)
      commentDict[comment.commentAttributes.id] = node
      pathToCommentMap[comment.commentAttributes.path] = comment.commentAttributes.id
    }

    return (commentDict, pathToCommentMap)
  }

  /// Determines if a comment is a root comment based on its path components.
  ///
  /// - Parameter pathComponents: The components of the comment's path (split by ".")
  /// - Returns: `true` if the comment is a root comment (direct child of "0"), `false` otherwise
  ///
  /// Root comments have paths in the format: "0.<commentID>"
  ///
  private static func isRootComment(pathComponents: [String]) -> Bool {
    pathComponents.count == 2 && pathComponents[0] == "0"
  }

  /// Establishes parent-child relationships between comments.
  ///
  /// - Parameters:
  ///   - comment: The child comment to link
  ///   - pathComponents: The path components of the child comment
  ///   - mutableDict: Reference to the dictionary of nodes being modified
  ///   - pathToCommentMap: Dictionary mapping paths to comment IDs
  ///
  /// This method works by:
  /// 1. Walking up the path hierarchy to find the nearest existing parent
  /// 2. Adding the child to the parent's children array
  /// 3. Updating the mutable dictionary with the modified parent
  ///
  private static func linkChildToParent(
    comment: Comment,
    pathComponents: [String],
    mutableDict: inout [Int: CommentNode],
    pathToCommentMap: [String: Int])
  {
    var parentPathComponents = pathComponents.dropLast()

    while !parentPathComponents.isEmpty {
      let parentPath = parentPathComponents.joined(separator: ".")

      if
        let parentCommentId = pathToCommentMap[parentPath],
        var parentNode = mutableDict[parentCommentId],
        let childNode = mutableDict[comment.commentAttributes.id]
      {
        parentNode.children.append(childNode)
        mutableDict[parentCommentId] = parentNode
        break
      }

      parentPathComponents = parentPathComponents.dropLast()
    }
  }

  /// Recursively sorts a comment tree by publication date (newest first).
  ///
  /// - Parameter nodes: Array of CommentNodes to sort
  /// - Returns: New array of CommentNodes sorted recursively by published date
  ///
  /// Sorting is performed:
  /// 1. First at the current level (root nodes or children of a parent)
  /// 2. Then recursively for all child nodes
  ///
  private static func sortTree(nodes: [CommentNode]) -> [CommentNode] {
    nodes
      .sorted { $0.comment.commentAttributes.published > $1.comment.commentAttributes.published }
      .map { node in
        var mutableNode = node
        mutableNode.children = sortTree(nodes: node.children)
        return mutableNode
      }
  }
}
