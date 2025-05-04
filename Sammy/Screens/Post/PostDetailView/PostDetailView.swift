import Models
import Networking
import OSLog
import SwiftUI

// MARK: - PostDetailView

struct PostDetailView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var viewModel: PostDetailViewModel

    init(post: Post) {
        viewModel = PostDetailViewModel(post: post)
    }

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: .paddingMedium) {
                titleSection
                contentSection
                commentSection
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                HStack(spacing: .paddingMedium) {
                    Button(action: { dismiss() }, label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: .iconSizeSmall))
                            .foregroundStyle(.textPrimary)
                    })
                    VStack(alignment: .leading, spacing: .paddingExtraSmall) {
                        Text("What's your favorite game?")
                            .font(.system(size: .fontSizeBody, weight: .medium))
                            .foregroundStyle(.textPrimary)
                        Text("c/programming")
                            .font(.system(size: .fontSizeCaption, weight: .light))
                            .foregroundStyle(.textSecondary)
                    }
                }
            }
        }
        .task {
            await viewModel.fetchCommentsForPost()
        }
        .navigationBarBackButtonHidden()
        .padding(.paddingSmall)
    }
}

// MARK: - Subviews

extension PostDetailView {

    private var titleSection: some View {
        VStack {
            HStack {
                Button(action: { }, label: {
                    Text(viewModel.post.communityData.name)
                        .font(.system(size: .fontSizeCaption, weight: .medium))
                        .foregroundStyle(Color.accentColor)
                })
                .buttonStyle(.plain)

                TinyCircleSeparator()

                Text("Posted by u/\(viewModel.post.creator.name)")
                    .font(.system(size: .fontSizeCaption, weight: .light))
                    .foregroundStyle(.textSecondary)

                TinyCircleSeparator()

                Text("2h")
                    .font(.system(size: .fontSizeCaption, weight: .light))
                    .foregroundStyle(.textSecondary)
            }

            Text(viewModel.post.postData.name)
                .font(.system(size: .fontSizeTitle, weight: .bold, design: .serif))
                .foregroundStyle(.textPrimary)
        }
    }

    private var contentSection: some View {
        VStack(alignment: .leading) {
            if let body = viewModel.post.postData.body {
                Text(body)
                    .font(.system(size: .fontSizeBody))
                    .foregroundStyle(.textPrimary)
            }

            if let imageURL = viewModel.post.postData.imageURL {
                PostImage(imageURL: imageURL)
            }

            PostInteractionBar(postCounts: viewModel.post.postCounts, onUpvote: {}, onDownvote: {}, onShare: {}, onBookmark: {})
        }
    }

    private var commentSection: some View {
        VStack(alignment: .leading) {
            ForEach(viewModel.comments) { comment in
                CommentRow(
                    comment: comment,
                    onUpvote: {
                        viewModel.handleVote(.upvote, commentID: comment.id)
                    },
                    onDownvote: {
                        viewModel.handleVote(.downvote, commentID: comment.id)
                    })
            }
        }
    }

}
