import SwiftUI
import Models

struct CommunitiesView: View {
	 @State private var selectedTab: Tab = .myCommunities
	 @State private var viewModel = CommunitiesViewModel()
	 @State var textValue: String = ""

	 enum Tab {
			case myCommunities
			case discover
	 }

	 var body: some View {
			VStack {
				 SearchBar(text: $textValue)

				 HStack(spacing: 15) {
						TabButton(title: "My Communities", isSelected: selectedTab == .myCommunities) {
							 selectedTab = .myCommunities
						}

						TabButton(title: "Discover", isSelected: selectedTab == .discover) {
							 selectedTab = .discover
						}

						Spacer()
				 }
				 .padding(20)
				 .overlay(Divider(), alignment: .bottom)

						// Main Content
				 VStack {
						if selectedTab == .myCommunities {
							 MyCommunitiesView(viewModel: viewModel, searchText: textValue)
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

import SwiftUI

struct MyCommunitiesView: View {
	 let viewModel: CommunitiesViewModel
	 let searchText: String

	 var filteredCommunities: [Community] {
			guard !searchText.isEmpty else { return viewModel.communities }

			return viewModel.communities.filter {
				 $0.communityData.name.lowercased().contains(searchText.lowercased())
			}
	 }

	 var body: some View {
			ScrollView {
				 if filteredCommunities.isEmpty && !searchText.isEmpty {
						VStack(spacing: 10) {
							 Image(systemName: "magnifyingglass.circle.fill")
									.resizable()
									.scaledToFit()
									.frame(width: 60, height: 60)
									.foregroundColor(.gray.opacity(0.6))
							 Text("No communities found")
									.font(.headline)
									.foregroundColor(.gray)
							 Text("Try a different search term")
									.font(.subheadline)
									.foregroundColor(.gray.opacity(0.8))
						}
						.padding(.top, 50)
						.padding(.horizontal)
						.frame(maxWidth: .infinity, alignment: .center)
				 } else {
						ForEach(filteredCommunities) { community in
							 HStack {
									if let iconURL = community.communityData.iconURL {
										 AsyncImage(url: iconURL) { phase in
												switch phase {
													 case .empty:
															ProgressView()
													 case .success(let image):
															image
																 .resizable()
																 .scaledToFit()
																 .frame(width: 50, height: 50)
																 .clipShape(Circle())
													 case .failure:
															Image(systemName: "exclamationmark.triangle")
																 .resizable()
																 .scaledToFit()
																 .frame(width: 50, height: 50)
													 @unknown default:
															EmptyView()
												}
										 }
									} else {
										 Image(systemName: "photo.circle.fill")
												.resizable()
												.scaledToFit()
												.frame(width: 50, height: 50)
												.scaleEffect(0.8)
									}

									VStack(alignment: .leading, spacing: 6) {
										 Text(community.communityData.name)
												.font(.headline)
												.lineLimit(1)
										 HStack(spacing: 3) {
												Image(systemName: "person.fill")
													 .foregroundStyle(.secondary)
												Text("\(community.countsData.subscribers) members")
													 .font(.system(size: 14))
													 .foregroundStyle(.gray.opacity(0.9))
													 .lineLimit(1)
										 }
										 Text(community.communityData.description ?? "No description")
												.font(.system(size: 15))
												.foregroundColor(.gray)
												.lineLimit(1)
									}

									Spacer()

									Button(action: {
												// Join action
									}) {
										 Text("Join")
												.font(.callout)
												.padding(.horizontal, 16)
												.padding(.vertical, 6)
												.background(Color.blue.opacity(0.1))
												.foregroundColor(.blue)
												.cornerRadius(8)
									}
							 }
							 Divider()
						}
						.padding(.horizontal)
						.padding(.vertical, 5)
				 }
			}
	 }
}

struct SearchBar: View {
	 @Binding var text: String

	 var body: some View {
			TextField("Search", text: $text)
				 .padding(.horizontal, 36) // Extra padding for icon
				 .padding(.vertical, 10)
				 .overlay(
						RoundedRectangle(cornerRadius: 8)
							 .stroke(Color.gray.opacity(0.3), lineWidth: 1)
				 )
				 .font(.system(size: 16, weight: .regular, design: .rounded))
				 .foregroundColor(.black)
				 .overlay(
						Image(systemName: "magnifyingglass")
							 .foregroundColor(.gray.opacity(0.6))
							 .frame(maxWidth: .infinity, alignment: .leading)
							 .padding(.leading, 12),
						alignment: .leading
				 )
				 .padding(.horizontal, 16)
				 .padding(.top, 20)
	 }
}

struct DiscoverView: View {
	 var viewModel: CommunitiesViewModel

	 var body: some View {
				 Text("No communities loaded.")
						.foregroundColor(.gray)
						.padding()
	 }
}

struct TabButton: View {
	 var title: String
	 var isSelected: Bool
	 var action: () -> Void

	 var body: some View {
			Text(title)
				 .foregroundColor(isSelected ? .purple : .gray)
				 .bold(isSelected)
				 .onTapGesture {
						action()
				 }
	 }
}


#Preview {
	 CommunitiesView()
}
