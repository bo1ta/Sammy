import SwiftUI

struct ProfileTabs: View {
    let tabNames: [String]
    @Binding var selectedTab: String

    var body: some View {
        HStack {
            ForEach(tabNames, id: \.self) { tab in
                VStack {
                    Text(tab)
                        .foregroundColor(selectedTab == tab ? .purple : .gray)
                        .fontWeight(selectedTab == tab ? .semibold : .regular)
                    Rectangle()
                        .fill(selectedTab == tab ? Color.purple : Color.clear)
                        .frame(height: 2)
                }
                .onTapGesture {
                    withAnimation {
                        selectedTab = tab
                    }
                }
            }
        }
        .padding(.top)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color.gray.opacity(0.3)),
            alignment: .bottom)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color.gray.opacity(0.3)),
            alignment: .top)
    }
}
