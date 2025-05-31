import Models
import SwiftUI

struct CommunitiesView: View {
    @State private var viewModel = CommunitiesViewModel()

    var body: some View {
        VStack {
            SearchBar(text: $viewModel.searchText)
            filteringTabs

            switch viewModel.currentTab {
            case .myCommunities:
                MyCommunitiesView(
                    viewModel: viewModel,
                    searchText: $viewModel.searchText)

            case .discover:
                DiscoverView(viewModel: viewModel)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .task {
            await viewModel.loadCommunities()
        }
    }
}

// MARK: - Subviews

extension CommunitiesView {
    var filteringTabs: some View {
        HStack(spacing: .paddingExtraLarge) {
            ForEach(CommunityTabs.allCases) { tab in
                Button(tab.title) {
                    viewModel.currentTab = tab
                }
                .buttonStyle(CommunityButtonStyle(isSelected: viewModel.currentTab == tab))
            }
            Spacer()
        }
        .padding(.paddingLarge)
        .overlay(Divider(), alignment: .bottom)
    }
}

#Preview {
    CommunitiesView()
}
