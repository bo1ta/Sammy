import SwiftUI

struct SearchView: View {
    @State private var viewModel = SearchViewModel()

    var body: some View {
        NavigationStack{
            ScrollView{
                HStack {
                    Image(.icTrending)
                        .resizable()
                        .scaledToFit()
                        .frame(width: .iconSizeSmall, height: .iconSizeSmall)
                    Text("Trending Today")
                        .font(.system(size: .fontSizeSubheadline, weight: .medium))
                    Spacer()
                }
                .padding(.horizontal, .screenEdgePadding)
                .padding(.bottom, .paddingSmall)

                VStack(alignment: .leading){
                    ForEach(viewModel.trendingItems) {item in
                        TrendingCard(item: item)
                            .padding(.bottom, .paddingSmall)
                    }
                }
                .padding(.horizontal, .screenEdgePadding)

            }

        }
        .searchable(text: $viewModel.searchText, prompt: "Search posts, communities, users")
    }
}

#Preview {
    SearchView()
}
