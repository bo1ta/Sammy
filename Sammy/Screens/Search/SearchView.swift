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
                    Spacer()
                }
                .padding(.horizontal, CGFloat.screenEdgePadding)
                VStack(alignment: .leading){
                    ForEach(viewModel.trendingItems) {item in
                        TrendingCard(item: item)
                    }
                    .padding(.horizontal, CGFloat.screenEdgePadding)
                Spacer()
            }
            .searchable(text: $searchText, prompt: "Search posts, communities, users")
            }
        }
    }
}

#Preview {
    SearchView()
}
