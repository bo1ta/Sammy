import Foundation
import SwiftUI

struct PostsView: View {
    @State private var viewModel = PostsViewModel()

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 15) {
                ForEach(viewModel.posts) { post in
                    PostCard(post: post)
                }
            }
        }
        .task {
            await viewModel.loadPosts()
        }
    }
}

#Preview {
    PostsView()
}
