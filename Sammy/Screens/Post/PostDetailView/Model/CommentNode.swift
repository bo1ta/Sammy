import Foundation
import Models

/// A node in a hierarchical comment tree that wraps a `Comment` with additional tree-specific metadata.
///
/// `CommentNode` serves as the fundamental building block for organizing comments into a nested tree structure.
/// It implements `Identifiable` to enable SwiftUI list rendering and diffing.
///
/// ## Key Responsibilities:
/// 1. Wraps a `Comment` with tree-specific information (depth, children)
/// 2. Provides unique identification for SwiftUI rendering
/// 3. Maintains parent-child relationships between comments
///
struct CommentNode: Identifiable {
    /// The unique identifier matching the wrapped comment's ID
    var id: Int

    /// The actual comment content and metadata
    var comment: Comment

    /// Child comments in the reply hierarchy
    var children: [CommentNode]

    /// The nesting depth in the comment tree (0 for root comments)
    var depth: Int

    /// Creates a comment node from a base comment
    ///
    /// - Parameters:
    ///   - comment: The base comment to wrap
    ///   - children: Immediate child/reply comments (default empty)
    ///   - depth: Nesting level in the hierarchy (default 0)
    ///
    init(comment: Comment, children: [CommentNode] = [], depth: Int = 0) {
        self.id = comment.id
        self.comment = comment
        self.children = children
        self.depth = depth
    }
}
