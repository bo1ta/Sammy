import Models
import SwiftUI

struct PostBodyView: View {
  var post: Post

  var body: some View {
    VStack(alignment: .leading, spacing: .paddingLarge) {
      PostAuthorView(post: post)

      Text(post.attributes.name)
        .font(.system(size: .fontSizeHeadline, weight: .bold, design: .rounded))
        .foregroundStyle(.textPrimary)

      if let body = post.attributes.body {
        Text(body)
          .font(.system(size: .fontSizeSubheadline))
          .foregroundStyle(.textPrimary)
      }

      if let imageURL = post.attributes.imageURL {
        PostImage(imageURL: imageURL)
      }

      PostInteractionBar(
        postCounts: post.postCounts,
        onUpvote: { },
        onDownvote: { },
        onShare: { },
        onBookmark: { })
    }
    .padding()
    .background(Color.card, in: .rect)
    .padding(.horizontal, .paddingSmall)
    .overlay {
      Rectangle()
        .strokeBorder(.gray, lineWidth: 0.15)
        .shadow(radius: 1)
    }
  }
}
