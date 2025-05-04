import SwiftUI
import Models

struct TrendingCard: View {
    let item: TrendingItem

    var body: some View {
        HStack{
            VStack(alignment: .leading) {
                Text("#\(item.rank) Trending")
                    .font(.system(size: .fontSizeSubheadline, weight: .light))
                Text(item.title)
            }
            .padding(.vertical, CGFloat.paddingSmall)
            Spacer()
            Text(item.postCount)
        }
        .padding()
        .background(Color.primaryBackground)
        .cornerRadius(CGFloat.cornerRadiusSmall)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        .onTapGesture {
            print("tap")
        }

    }
}
