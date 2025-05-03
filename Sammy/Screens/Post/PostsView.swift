import Foundation
import SwiftUI

struct PostsView: View {
    @State private var viewModel = PostsViewModel()

    var body: some View {
        ScrollView {
            LazyVStack(spacing: .paddingLarge) {
                ForEach(viewModel.posts) { post in
                    PostCard(post: post)
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
