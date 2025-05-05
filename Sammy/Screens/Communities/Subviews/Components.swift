	 //
	 //  Components.swift
	 //  Sammy
	 //
	 //  Created by Khanh Nguyen on 5/5/25.
	 //
import SwiftUI
import Models

struct MyCommunitiesView: View {
	 let viewModel: CommunitiesViewModel
	 @Binding var searchText: String

	 var filteredCommunities: [Community] {
			guard !searchText.isEmpty else { return viewModel.communities }
			return viewModel.communities.filter {
				 $0.communityData.name.lowercased().contains(searchText.lowercased())
			}
	 }

	 var body: some View {
			ScrollView {
				 if filteredCommunities.isEmpty && !searchText.isEmpty {
						VStack(spacing: .paddingSmall) {
							 Image(systemName: "magnifyingglass.circle.fill")
									.resizable()
									.scaledToFit()
									.frame(width: .iconSizeJumbo, height: .iconSizeJumbo)
									.foregroundColor(.gray.opacity(0.6))
							 Text("No communities found")
									.font(.headline)
									.foregroundColor(.gray)
							 Text("Try a different search term")
									.font(.subheadline)
									.foregroundColor(.gray.opacity(0.8))
						}
						.padding(.top, .paddingHuge)
						.padding(.horizontal, .screenEdgePadding)
						.frame(maxWidth: .infinity, alignment: .center)
				 } else {
						ForEach(filteredCommunities) { community in
							 HStack {
									if community.communityData.iconURL != nil {
										 asyncImageView(url: community.communityData.iconURL)
									} else {
										 Image(systemName: "photo.circle.fill")
												.resizable()
												.scaledToFit()
												.frame(width: .iconSizeJumbo, height: .iconSizeJumbo)
												.scaleEffect(0.8)
									}

									VStack(alignment: .leading, spacing: .paddingExtraSmall) {
										 Text(community.communityData.name)
												.font(.headline)
												.lineLimit(1)
										 HStack(spacing: .paddingExtraSmall) {
												Image(systemName: "person.fill")
													 .foregroundStyle(.secondary)
												Text("\(community.countsData.subscribers) members")
													 .font(.system(size: .fontSizeSubheadline))
													 .foregroundStyle(.gray.opacity(0.9))
													 .lineLimit(1)
										 }
										 Text(community.communityData.description ?? "No description")
												.font(.system(size: .fontSizeBody))
												.foregroundColor(.gray)
												.lineLimit(1)
									}

									Spacer()

									Button(action: {
												// Join action
									}) {
										 Text("Join")
												.font(.callout)
												.padding(.horizontal, .paddingLarge)
												.padding(.vertical, .paddingExtraSmall)
												.background(Color.blue.opacity(0.1))
												.foregroundColor(.blue)
												.cornerRadius(.cornerRadiusSmall)
									}
							 }
							 Divider()
						}
						.padding(.horizontal, .screenEdgePadding)
						.padding(.vertical, .paddingExtraSmall)
				 }
			}
	 }
}

struct SearchBar: View {
	 @Binding var text: String

	 var body: some View {
			TextField("Search", text: $text)
				 .padding(.horizontal, .paddingJumbo)
				 .padding(.vertical, .paddingSmall)
				 .overlay(
						RoundedRectangle(cornerRadius: .cornerRadiusSmall)
							 .stroke(Color.gray.opacity(0.3), lineWidth: 1)
				 )
				 .font(.system(size: .fontSizeBody, weight: .regular, design: .rounded))
				 .overlay(
						Image(systemName: "magnifyingglass")
							 .foregroundColor(.gray.opacity(0.6))
							 .frame(maxWidth: .infinity, alignment: .leading)
							 .padding(.leading, .paddingMedium),
						alignment: .leading
				 )
				 .padding(.horizontal, .screenEdgePadding)
				 .padding(.top, .paddingExtraLarge)
	 }
}

struct DiscoverView: View {
	 var viewModel: CommunitiesViewModel

	 var body: some View {
			Text("No communities loaded.")
				 .foregroundColor(.gray)
				 .padding(.screenEdgePadding)
	 }
}

struct CommunityButtons: View {
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
enum tabOptions {
	 case myCommunities
	 case discover
}

struct asyncImageView: View {
	 let url: URL?

	 var body: some View {
			Group {
						AsyncImage(url: url) { phase in
							 switch phase {
									case .empty:
										 ProgressView()
									case .success(let image):
										 image
												.resizable()
												.scaledToFit()
												.frame(width: .iconSizeJumbo, height: .iconSizeJumbo)
												.clipShape(Circle())
									case .failure:
										 Image(systemName: "exclamationmark.triangle")
												.resizable()
												.scaledToFit()
												.frame(width: .iconSizeLarge, height: .iconSizeLarge)
									@unknown default:
										 EmptyView()
							 }
						}
			}
	 }
}
