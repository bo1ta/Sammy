import Models
import SwiftUI

struct PostInteractionBar: View {
  var postCounts: PostCounts
  var voteType: VoteType

  var onVote: (VoteType) -> Void
  var onShare: () -> Void
  var onBookmark: () -> Void

  var body: some View {
    HStack(alignment: .center, spacing: .paddingMedium) {
      voteStackButton
      commentsButton
      shareButton
      Text("Share")
        .font(.system(size: .fontSizeCaption, weight: .medium))
        .foregroundStyle(.textSecondary)
      bookmarkButton
      Text("Bookmark")
        .font(.system(size: .fontSizeCaption, weight: .medium))
        .foregroundStyle(.textSecondary)
    }
  }

  /// This will handle the voting actions (upvote, downvote)
  ///
  private var voteStackButton: some View {
    HStack {
      Button(action: {
        onVote(.upvote)
      }, label: {
        Image(.icArrow)
          .resizable()
          .renderingMode(.template)
          .scaledToFit()
          .frame(height: .iconSizeMedium)
          .opacity(voteType == .upvote ? 1.0 : 0.8)
          .foregroundStyle(voteType == .upvote ? Color.clear : Color.accent)
      })

      Text(String(postCounts.score))
        .font(.system(size: .fontSizeCaption, weight: .medium))
        .foregroundStyle(.textSecondary)

      Button(action: {
        onVote(.downvote)
      }, label: {
        Image(.icArrow)
          .resizable()
          .renderingMode(.template)
          .scaledToFit()
          .rotationEffect(.degrees(180))
          .frame(height: .iconSizeMedium)
          .opacity(voteType == .downvote ? 1.0 : 0.8)
          .foregroundStyle(voteType == .downvote ? Color.clear : Color.accent)
      })
    }
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
          .font(.system(size: .fontSizeSubheadline, weight: .medium))
          .foregroundStyle(.textSecondary)
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
