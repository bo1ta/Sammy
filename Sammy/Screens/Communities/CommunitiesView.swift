import SwiftUI

struct CommunitiesView: View {
    @State private var viewModel = CommunitiesViewModel()

    var body: some View {
        VStack {
            Text("Hello!")

            if !viewModel.communities.isEmpty {
                ForEach(viewModel.communities) { community in
                    Text(community.communityData.name)
                }
            }
        }
        .task {
            await viewModel.loadCommunities()
        }
    }
}
