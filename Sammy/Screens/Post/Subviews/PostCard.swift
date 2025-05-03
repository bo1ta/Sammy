import Foundation
import Models
import SwiftUI

// MARK: - PostCard

struct PostCard: View {
    let post: Post

    var body: some View {
        VStack(alignment: .leading, spacing: .paddingMedium) {
            HStack {
                communityButton
                creatorButton
            }
            .padding([.horizontal, .bottom])

            if post.postData.imageURL != nil {
                postImage
            } else {
                Text(post.postData.name)
                    .padding(.horizontal)
            }

            HStack {
                voteStackButton
                commentsButton
                Spacer()
                shareButton
                bookmarkButton
            }
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
            Text("c/\(post.communityData.name)")
                .font(.system(size: .fontSizeCaption, weight: .medium))
                .foregroundStyle(Color.purple)
        })
        .buttonStyle(.plain)
    }

    /// This will navigate to the `CreatorView`
    ///
    private var creatorButton: some View {
        Button(action: { }, label: {
            Text("Posted by u/\(post.creatorData.name)")
                .font(.system(size: .fontSizeCaption, weight: .regular))
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

    private var postImage: some View {
        AsyncImage(url: post.postData.imageURL) { imagePhase in
            switch imagePhase {
            case .empty:
                Color.white
                    .frame(maxWidth: .infinity)
                    .frame(height: 200)

            case .success(let image):
                image.resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)

            case .failure(let error):
                Color.white
                    .frame(maxWidth: .infinity)
                    .frame(height: 200)
                    .onAppear {
                        print(error.localizedDescription)
                    }

            @unknown default:
                fatalError("Unknown default")
            }
        }
    }

    /// This will handle the voting actions (upvote, downvote)
    ///
    private var voteStackButton: some View {
        HStack {
            Image(systemName: "arrow.up")
            Text(String(post.countsData.score))
            Image(systemName: "arrow.down")
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
                Text(String(post.countsData.comments))
            }
        })
        .buttonStyle(.plain)
    }
}
