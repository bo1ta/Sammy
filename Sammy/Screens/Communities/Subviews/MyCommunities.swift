import Models
import SwiftUI

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
            if filteredCommunities.isEmpty, !searchText.isEmpty {
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
                            AsyncImageView(url: community.communityData.iconURL)
                        } else {
                            Image(systemName: "photo.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: .iconSizeJumbo, height: .iconSizeJumbo)
																.clipShape(Circle())
                        }

                        VStack(alignment: .leading, spacing: .paddingExtraSmall) {
													 Text("c/\(community.communityData.name)")
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
                            print("Joined")
                        }, label: {
                            Text("Join")
                                .font(.callout)
                                .padding(.horizontal, .paddingLarge)
                                .padding(.vertical, .paddingExtraSmall)
                                .background(Color.blue.opacity(0.1))
                                .foregroundColor(.blue)
                                .cornerRadius(.cornerRadiusSmall)
                        })
                    }
                    Divider()
                }
                .padding(.horizontal, .screenEdgePadding)
                .padding(.vertical, .paddingExtraSmall)
            }
        }
    }
}
