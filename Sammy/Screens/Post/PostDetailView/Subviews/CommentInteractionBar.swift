import SwiftUI
import Models

struct CommentInteractionBar: View {
  var comment: Comment

  var onUpvote: () -> Void
  var onDownvote: () -> Void
  var onReply: () -> Void

  var body: some View {
    HStack(alignment: .center, spacing: .paddingMedium) {
      Spacer()
      Button(action: onReply, label: {
        Text("Reply")
          .font(.system(size: .fontSizeCaption, weight: .medium))
          .foregroundStyle(.textSecondary)
      })
      .buttonStyle(.plain)

      voteStackButton
    }
  }

  private var voteStackButton: some View {
    HStack {
      Button(action: onUpvote, label: {
        Image(.icArrow)
          .resizable()
          .renderingMode(.template)
          .scaledToFit()
          .frame(height: .iconSizeMedium)
          .opacity(0.8)
      })
      .buttonStyle(.plain)

      Text(String(comment.countsData.score))
        .font(.system(size: .fontSizeCaption, weight: .medium))
        .foregroundStyle(.textSecondary)

      Button(action: onDownvote, label: {
        Image(.icArrow)
          .resizable()
          .renderingMode(.template)
          .scaledToFit()
          .rotationEffect(.degrees(180))
          .frame(height: .iconSizeMedium)
          .opacity(0.8)
      })
      .buttonStyle(.plain)
    }
  }
}
