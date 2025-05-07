import Foundation
import SwiftUI

struct PostsView: View {
    @State private var viewModel = PostsViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: .paddingLarge) {
                    ForEach(viewModel.posts) { post in
                        Button(action: {
                            viewModel.selectedDestination = .detail(post)
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
            .navigationDestination(item: $viewModel.selectedDestination) { destination in
                switch destination {
                case .detail(let post):
                    PostDetailView(post: post)
                }
            }
        }
    }
}

#Preview {
    PostsView()
}
