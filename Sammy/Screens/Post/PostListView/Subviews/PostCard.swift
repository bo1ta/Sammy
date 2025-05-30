import Foundation
import Models
import SwiftUI

// MARK: - PostCard

struct PostCard: View {
    let post: Post

    var body: some View {
        VStack(alignment: .center, spacing: .paddingMedium) {
            HStack {
                communityButton
                creatorButton
                Spacer()
            }
            .padding([.horizontal, .bottom])

            if let imageURL = post.attributes.imageURL {
                PostImage(imageURL: imageURL)
            } else {
                Text(post.attributes.name)
                    .padding(.horizontal)
                    .foregroundStyle(.textPrimary)
                    .font(.system(size: .fontSizeBody, weight: .regular))
            }

            PostInteractionBar(postCounts: post.postCounts, onUpvote: { }, onDownvote: { }, onShare: { }, onBookmark: { })
                .padding([.horizontal, .vertical])
        }
        .padding(.vertical, .paddingSmall)
        .padding(.top, .paddingSmall)
        .background(Color.gray.opacity(0.07), in: .rect)
    }
}

// MARK: - Subviews

extension PostCard {

    /// This will navigate to the `CommunityView`
    ///
    private var communityButton: some View {
        Button(action: { }, label: {
            Text("c/\(post.communityAttributes.name)")
                .font(.system(size: .fontSizeCaption, weight: .medium))
                .foregroundStyle(Color.purple)
        })
        .buttonStyle(.plain)
    }

    /// This will navigate to the `CreatorView`
    ///
    private var creatorButton: some View {
        Button(action: { }, label: {
            Text("Posted by u/\(post.creator.name)")
                .font(.system(size: .fontSizeCaption, weight: .regular))
        })
        .buttonStyle(.plain)
    }
}
