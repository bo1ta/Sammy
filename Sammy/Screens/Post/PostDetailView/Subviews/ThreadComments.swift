import SwiftUI

/// A view that displays a hierarchical thread of comments with visual threading indicators.
///
/// This view takes a tree of `CommentNode` objects and renders them with:
/// - Proper indentation based on comment depth
/// - Visual thread lines connecting replies
/// - Color-coded threading indicators for deep nesting
///
struct ThreadComments: View {
    var commentTree: [CommentNode]

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(commentTree) { comment in
                    ThreadedCommentNode(node: comment)
                }
            }
        }
    }
}

/// A recursive view that renders a single comment and its reply thread.
///
/// Displays:
/// - The comment content with voting controls
/// - Visual threading lines for nested replies
/// - Proper indentation based on comment depth
///
/// The view uses a color rotation system to distinguish different nesting levels.
///
struct ThreadedCommentNode: View {
    let node: CommentNode

    private let threadColors: [Color] = [
        .blue, .green, .orange, .red, .purple, .pink
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: .paddingMedium) {
            CommentRow(node: node, depth: 0, onUpvote: {}, onDownvote: {})
                .padding(.leading, CGFloat(node.depth) * 12)

            ForEach(node.children) { childNode in
                HStack {
                    ForEach(0..<childNode.depth, id: \.self) { index in
                        Rectangle()
                            .fill(threadColors[index % threadColors.count])
                            .frame(width: 2)
                            .padding(.horizontal, 5)
                    }

                    /// Recursively render child comment
                    ThreadedCommentNode(node: childNode)
                }
            }
        }
    }
}
