import Models
import Networking
import OSLog
import SwiftUI

// MARK: - PostDetailViewModel

@Observable
@MainActor
final class PostDetailViewModel: ObservableObject {
    @ObservationIgnored private(set) var voteTask: Task<Void, Never>?

    private(set) var comments: [Comment] = []

    let post: Post

    private let logger = Logger(subsystem: "com.Sammy", category: "PostDetailViewModel")
    private let commentService: CommentServiceProtocol

    init(post: Post, commentService: CommentServiceProtocol = CommentService()) {
        self.post = post
        self.commentService = commentService
    }

    func fetchCommentsForPost() async {
        do {
            comments = try await commentService.getAllForPostID(post.id, queryOptions: nil)
        } catch {
            logger.error("Error loading cmments. Error: \(error.localizedDescription)")
        }
    }

    func handleVote(_ voteType: VoteType, commentID: Comment.ID) {
        voteTask?.cancel()

        voteTask = Task {
            do {
                try await commentService.setVoteForComment(commentID, voteType: voteType)
            } catch {
                logger.error("Error voting comment. Error: \(error.localizedDescription)")
            }
        }
    }
}

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
            } else if let imageURL = viewModel.post.postData.imageURL {
                PostImage(imageURL: imageURL)
            }
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

// MARK: - TinyCircleSeparator

struct TinyCircleSeparator: View {
    var body: some View {
        Circle()
            .fill(Color.textPrimary)
            .frame(height: 2)
    }
}

// MARK: - CommentRow

struct CommentRow: View {
    let comment: Comment
    let onUpvote: () -> Void
    let onDownvote: () -> Void

    var body: some View {
        VStack(spacing: .paddingMedium) {
            HStack {
                Text("u/\(comment.creator.name)")
                    .font(.system(size: .fontSizeCaption, weight: .medium))
                    .foregroundStyle(.textPrimary)
                TinyCircleSeparator()
                Text("1h")
            }

            Text(comment.commentData.content)
                .font(.system(size: .fontSizeBody, weight: .regular))
                .foregroundStyle(.textPrimary)
                .opacity(0.95)

            HStack(spacing: .paddingSmall) {
                upvoteButton
                Text(String(comment.countsData.score))
                    .font(.system(size: .fontSizeCaption, weight: .bold))
                    .foregroundStyle(.textPrimary)
                downvoteButton
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
