import SwiftUI
import Models

struct CommentRow: View {
    let comment: Comment
    let onUpvote: () -> Void
    let onDownvote: () -> Void

    var body: some View {
        VStack(spacing: .paddingMedium) {
            HStack {
                Text("u/\(comment.creator.name)")
                    .font(.system(size: .fontSizeCaption, weight: .medium))
                    .foregroundStyle(.textPrimary)
                TinyCircleSeparator()
                Text("1h")
            }

            Text(comment.commentData.content)
                .font(.system(size: .fontSizeBody, weight: .regular))
                .foregroundStyle(.textPrimary)
                .opacity(0.95)

            HStack(spacing: .paddingSmall) {
                upvoteButton
                Text(String(comment.countsData.score))
                    .font(.system(size: .fontSizeCaption, weight: .bold))
                    .foregroundStyle(.textPrimary)
                downvoteButton
            }
        }
    }

}

extension CommentRow {
    private var upvoteButton: some View {
        Button(action: onUpvote, label: {
            Image(systemName: "arrow.up")
                .foregroundStyle(.textPrimary)
                .font(.system(size: .iconSizeSmall))
        })
    }

    private var downvoteButton: some View {
        Button(action: onDownvote) {
            Image(systemName: "arrow.down")
                .foregroundStyle(.textPrimary)
                .font(.system(size: .iconSizeSmall))
        }
    }
}
