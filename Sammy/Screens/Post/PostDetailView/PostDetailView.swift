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
        PostBodyView(post: viewModel.post, onVote: viewModel.votePost(_:), onShare: {}, onBookmark: {})
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
  private var commentSection: some View {
    VStack(alignment: .leading) {
      HStack {
        Text("SORT BY")
          .font(.system(size: .fontSizeCaption, weight: .medium))
          .foregroundStyle(.textSecondary)
        Text("BEST")
          .font(.system(size: .fontSizeCaption, weight: .bold))
          .foregroundStyle(.accent)
        Image(systemName: "chevron.down")
          .renderingMode(.template)
          .resizable()
          .scaledToFit()
          .frame(height: .paddingExtraSmall)

        Spacer()

        Image(systemName: "magnifyingglass")
          .renderingMode(.template)
          .resizable()
          .scaledToFit()
          .frame(height: .iconSizeSmall)
      }
      .padding(.paddingMedium)
      Divider()

      ThreadComments(commentTree: viewModel.commentTree)
    }
    .padding(.paddingSmall)
    .background(Color.card, in: .rect)
    .padding(.horizontal, .paddingSmall)
    .overlay {
      Rectangle()
        .strokeBorder(.gray, lineWidth: 0.15)
        .shadow(radius: 1)
    }
  }

}
