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
                        Text(viewModel.post.postData.name)
                            .font(.system(size: .fontSizeBody, weight: .medium))
                            .foregroundStyle(.textPrimary)
                        Text("c/\(viewModel.post.communityData.name)")
                            .font(.system(size: .fontSizeCaption, weight: .light))
                            .foregroundStyle(.textSecondary)
                    }
                }
            }
        }
        .task {
            await viewModel.fetchCommentsForPost()
        }
        .background(Color.primaryBackground)
        .navigationBarBackButtonHidden()
    }
}

// MARK: - Subviews

extension PostDetailView {

    private var titleSection: some View {
        VStack(alignment: .leading) {
            HStack {
                Button(action: { }, label: {
                    Text("c/\(viewModel.post.communityData.name)")
                        .font(.system(size: .fontSizeCaption, weight: .medium))
                        .foregroundStyle(Color.accentColor)
                })
                .buttonStyle(.plain)
                .padding(.trailing, .paddingMedium)

                TinyCircleSeparator()

                Text("Posted by u/\(viewModel.post.creator.name)")
                    .font(.system(size: .fontSizeCaption, weight: .light))
                    .foregroundStyle(.textSecondary)

                TinyCircleSeparator()

                Text("2h")
                    .font(.system(size: .fontSizeCaption, weight: .light))
                    .foregroundStyle(.textSecondary)
                Spacer()
            }

            Text(viewModel.post.postData.name)
                .font(.system(size: .fontSizeTitle, weight: .bold, design: .serif))
                .foregroundStyle(.textPrimary)
        }
    }

    private var contentSection: some View {
        VStack(alignment: .leading, spacing: .paddingLarge) {
            titleSection

            if let body = viewModel.post.postData.body {
                Text(body)
                    .font(.system(size: .fontSizeBody))
                    .foregroundStyle(.textPrimary)
            }

            if let imageURL = viewModel.post.postData.imageURL {
                PostImage(imageURL: imageURL)
            }

            PostInteractionBar(
                postCounts: viewModel.post.postCounts,
                onUpvote: { },
                onDownvote: { },
                onShare: { },
                onBookmark: { })
        }
        .padding()
        .background(Color.card, in: .rect)
        .overlay {
            Rectangle()
                .strokeBorder(.gray, lineWidth: 0.15)
                .shadow(radius: 1)
        }
    }

    private var commentSection: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Comments")
                    .font(.system(size: .fontSizeSubheadline, weight: .medium))
                    .foregroundStyle(.textPrimary)

                Spacer()

                Button(action: { }, label: {
                    Text("Sort by Best")
                        .foregroundStyle(Color.accent)
                        .font(.system(size: .fontSizeCaption, weight: .regular))
                })
                .buttonStyle(.plain)
            }
            .padding(.bottom, .paddingMedium)

            ThreadComments(commentTree: viewModel.commentTree)
        }
        .padding()
        .background(Color.card, in: .rect)
        .overlay {
            Rectangle()
                .strokeBorder(.gray, lineWidth: 0.15)
                .shadow(radius: 1)
        }
    }

}
