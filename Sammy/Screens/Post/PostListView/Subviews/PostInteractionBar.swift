import Models
import SwiftUI

struct PostInteractionBar: View {
    var postCounts: PostCounts

    var onUpvote: () -> Void
    var onDownvote: () -> Void
    var onShare: () -> Void
    var onBookmark: () -> Void

    var body: some View {
        HStack {
            voteStackButton
            commentsButton
            Spacer()
            shareButton
            bookmarkButton
        }
    }

    /// This will handle the voting actions (upvote, downvote)
    ///
    private var voteStackButton: some View {
        HStack {
            Button(action: onUpvote, label: {
                Image(systemName: "arrow.up")
                    .font(.system(size: .iconSizeSmall))
                    .foregroundStyle(.textPrimary)
            })

            Text(String(postCounts.score))
                .font(.system(size: .fontSizeCaption, weight: .medium))
                .foregroundStyle(.textPrimary)

            Button(action: onUpvote, label: {
                Image(systemName: "arrow.down")
                    .font(.system(size: .iconSizeSmall))
                    .foregroundStyle(.textPrimary)
            })
        }
        .padding(.paddingSmall)
        .background(Color.gray.opacity(0.15), in: .rect(cornerRadius: .cornerRadiusMedium))
    }

    /// This will navigate to the comment section for the given Post
    ///
    private var commentsButton: some View {
        Button(action: { }, label: {
            HStack {
                Image(.icChat)
                    .resizable()
                    .scaledToFit()
                    .frame(height: .iconSizeExtraSmall)
                Text(String(postCounts.comments))
            }
        })
        .buttonStyle(.plain)
    }

    /// This will present a share bottom sheet
    ///
    private var shareButton: some View {
        Button(action: { }, label: {
            Image(systemName: "square.and.arrow.up")
        })
        .buttonStyle(.plain)
    }

    /// This will bookmark the post (aka favorite)
    ///
    private var bookmarkButton: some View {
        Button(action: { }, label: {
            Image(systemName: "bookmark")
        })
        .buttonStyle(.plain)
    }
}
