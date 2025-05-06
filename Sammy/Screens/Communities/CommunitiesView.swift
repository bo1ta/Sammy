import Models
import SwiftUI

struct CommunitiesView: View {
	 @State private var selectedTab = CommunityFilteringTabs.myCommunities
	 @State private var viewModel = CommunitiesViewModel()

	 var body: some View {
			VStack {
				 SearchBar(text: $viewModel.searchText)

				 HStack(spacing: .paddingExtraLarge) {
						Button("My Communities") {
							 selectedTab = .myCommunities
						}
						.buttonStyle(CommunityButtonStyle(isSelected: selectedTab == .myCommunities))

						Button("Discover") {
							 selectedTab = .discover
						}
						.buttonStyle(CommunityButtonStyle(isSelected: selectedTab == .discover))

						Spacer()
				 }
				 .padding(20)
				 .overlay(Divider(), alignment: .bottom)

				 VStack {
						switch selectedTab {
						case .myCommunities:
									MyCommunitiesView(
										 viewModel: viewModel,
										 searchText: $viewModel.searchText
									)
						case .discover:
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
