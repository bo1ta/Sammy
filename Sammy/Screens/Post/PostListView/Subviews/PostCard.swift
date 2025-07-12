import Foundation
import Models
import SwiftUI

// MARK: - PostCard

struct PostCard: View {
  let post: Post

  var body: some View {
    VStack(alignment: .leading, spacing: .paddingMedium) {
      PostAuthorView(post: post)
        .frame(maxWidth: .infinity, alignment: .leading)

      if let imageURL = post.attributes.imageURL {
        PostImage(imageURL: imageURL)
      } else {
        Text(post.attributes.name)
          .padding(.horizontal)
          .foregroundStyle(.textPrimary)
          .font(.system(size: .fontSizeSubheadline, weight: .regular))
      }

      PostInteractionBar(postCounts: post.postCounts, voteType: post.voteType, onVote: { _ in }, onShare: { }, onBookmark: { })
        .padding([.horizontal, .vertical])
    }
    .frame(maxWidth: .infinity)
    .padding(.paddingSmall)
    .background {
      RoundedRectangle(cornerRadius: .cornerRadiusSmall)
        .fill(Color.card)
        .shadow(radius: 1.5)
    }
    .padding(.horizontal, .paddingSmall)
  }
}

// MARK: - Subviews

extension PostCard { }
