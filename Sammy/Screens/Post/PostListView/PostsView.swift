import Foundation
import SwiftUI

struct PostsView: View {
  @State private var viewModel = PostsViewModel()

  var body: some View {
      ScrollView {
        LazyVStack(spacing: .paddingLarge) {
          ForEach(viewModel.posts) { post in
            Button(action: {
              AppNavigator.shared.push(HomeDestinations.postDetail(post))
            }, label: {
              PostCard(post: post)
            })
            .buttonStyle(.plain)
          }
        }
      }
      .task {
        await viewModel.loadPosts()
      }
      .padding(.top, .paddingSmall)
    }
  }

#Preview {
  PostsView()
}
