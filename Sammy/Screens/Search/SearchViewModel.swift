import Foundation
import Models

final class SearchViewModel: ObservableObject {
    var trendingItems: [TrendingItem]

    init(trendingItems: [TrendingItem] = [
        TrendingItem(id: 1, rank: 1, title: "AI Developments", postCount: "12.4k posts"),
        TrendingItem(id: 2, rank: 2, title: "iPhone 16 Review", postCount: "8.9k posts"),
        TrendingItem(id: 3, rank: 3, title: "Climate Change Solutions", postCount: "4.5k posts"),
        TrendingItem(id: 4, rank: 4, title: "Web Development Tips", postCount: "2.3k posts"),
        TrendingItem(id: 5, rank: 5, title: "Recipe Ideas", postCount: "1.1k posts"),
        ]) {
            self.trendingItems = trendingItems
        }
}
