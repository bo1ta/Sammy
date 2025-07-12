import Models
import SwiftUI

// MARK: - CommentRow

struct CommentRow: View {
  @Binding var isCollapsed: Bool

  let node: CommentNode
  let depth: Int
  let onUpvote: () -> Void
  let onDownvote: () -> Void

  var body: some View {
    VStack(alignment: .leading, spacing: .paddingMedium) {
      HStack {
        AvatarImage(avatarURL: node.comment.avatarURL)

        Text("u/\(node.comment.creator.name)")
          .font(.system(size: .fontSizeCaption, weight: .medium))
          .foregroundStyle(.textPrimary)
          .padding(.trailing, .paddingMedium)
        TinyCircleSeparator()
        Text(DateHelper.relativeTimeFromString(node.comment.commentAttributes.published))
          .font(.system(size: .fontSizeCaption, weight: .medium))
          .foregroundStyle(.textPrimary)

        Spacer()

        if !node.children.isEmpty {
          Button(action: { isCollapsed.toggle() }, label: {
            Text(isCollapsed ? "Expand" : "Collapse")
              .font(.system(size: .fontSizeCaption, weight: .light))
              .foregroundStyle(.textSecondary)
          })
          .buttonStyle(.plain)
        }
      }

      if !isCollapsed {
        Text(node.comment.commentAttributes.content)
          .font(.system(size: .fontSizeSubheadline, weight: .regular))
          .foregroundStyle(.textPrimary)
          .opacity(0.95)
      }

      CommentInteractionBar(comment: node.comment, onUpvote: {}, onDownvote: {}, onReply: {})
    }
    .frame(maxWidth: .infinity)
    .padding(.paddingMedium)
    .onTapGesture {
      if !node.children.isEmpty {
        isCollapsed.toggle()
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

// MARK: - DateHelper

enum DateHelper {
  static func relativeTimeFromString(_ dateString: String) -> String {
    let dateFormatter = ISO8601DateFormatter()
    if let date = dateFormatter.date(from: dateString) {
      let components = Calendar.current.dateComponents([.hour], from: date, to: Date())
      if let hours = components.hour {
        return "\(hours)h"
      }
    }
    return "1h"
  }
}
