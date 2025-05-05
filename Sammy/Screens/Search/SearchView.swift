import SwiftUI

struct SearchView: View {
    @State private var searchText: String = ""
    @StateObject private var viewModel = SearchViewModel()

    var body: some View {
        NavigationStack{
            ScrollView{
                HStack {
                    Image("trending")
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
        .searchable(text: $searchText, prompt: "Search posts, communities, users")
    }
}

#Preview {
    SearchView()
}
