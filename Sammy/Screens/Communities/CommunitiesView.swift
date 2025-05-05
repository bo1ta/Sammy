import Models
import SwiftUI

struct CommunitiesView: View {
    @State private var selectedTab = TabOptions.myCommunities
    @State private var viewModel = CommunitiesViewModel()

    var body: some View {
        VStack {
            SearchBar(text: $viewModel.searchText)

            HStack(spacing: 15) {
                CommunityButtons(title: "My Communities", isSelected: selectedTab == .myCommunities) {
                    selectedTab = .myCommunities
                }

                CommunityButtons(title: "Discover", isSelected: selectedTab == .discover) {
                    selectedTab = .discover
                }

                Spacer()
            }
            .padding(20)
            .overlay(Divider(), alignment: .bottom)

            VStack {
                if selectedTab == .myCommunities {
                    MyCommunitiesView(
                        viewModel: viewModel,
                        searchText: $viewModel.searchText)
                } else {
                    DiscoverView(viewModel: viewModel)
                }
            }
            Spacer()
        }
        .task {
            await viewModel.loadCommunities()
        }
    }

}

#Preview {
    CommunitiesView()
}
