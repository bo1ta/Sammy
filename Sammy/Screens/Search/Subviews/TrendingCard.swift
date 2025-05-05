import SwiftUI
import Models

struct TrendingCard: View {
    let item: TrendingItem

    var body: some View {
        HStack{
            VStack(alignment: .leading, spacing: .paddingSmall) {
                Text("#\(item.rank) Trending")
                    .font(.system(size: .fontSizeSubheadline, weight: .light))
                Text(item.title)
                    .font(.system(size: .fontSizeSubheadline, weight: .medium))
            }
            Spacer()
            Text(item.postCount)
                .font(.system(size: .fontSizeSubheadline, weight: .light))
        }
        .padding()
        .background(Color.primaryBackground)
        .cornerRadius(CGFloat.cornerRadiusSmall)
        .shadow(color: Color.black.opacity(0.15), radius: 4, x: 0, y: 2)
    }
}
