import SwiftUI
import Models

struct CommentRow: View {
    @State private var isCollapsed = false

    let node: CommentNode
    let depth: Int
    let onUpvote: () -> Void
    let onDownvote: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: .paddingMedium) {
            HStack {
                Text("u/\(node.comment.creator.name)")
                    .font(.system(size: .fontSizeCaption, weight: .medium))
                    .foregroundStyle(.textPrimary)
                    .padding(.trailing, .paddingMedium)
                TinyCircleSeparator()
                Text(DateHelper.relativeTimeFromString(node.comment.commentData.published))
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
                Text(node.comment.commentData.content)
                    .font(.system(size: .fontSizeBody, weight: .regular))
                    .foregroundStyle(.textPrimary)
                    .opacity(0.95)
            }

            HStack(spacing: .paddingSmall) {
                upvoteButton

                Text(String(node.comment.countsData.score))
                    .font(.system(size: .fontSizeCaption, weight: .bold))
                    .foregroundStyle(.textPrimary)

                downvoteButton
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            if !node.children.isEmpty {
//                isCollapsed
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
