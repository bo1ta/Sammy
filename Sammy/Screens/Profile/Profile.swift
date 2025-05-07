import SwiftUI

struct ProfileView: View {
    @State private var selectedTab = "Posts"
    @State var viewModel = ProfileViewModel()
    @Environment(\.colorScheme) private var colorScheme
    var body: some View {
        VStack(alignment: .leading, spacing: .paddingExtraLarge) {
            ProfileSection()
            ProfileButtons()
            ProfileTabs(tabNames: viewModel.tabNames, selectedTab: $selectedTab)

            VStack(alignment: .leading, spacing: .paddingExtraLarge) {
                ForEach(viewModel.menuItems) { item in
                    HStack(spacing: .paddingMedium) {
                        Image(systemName: item.icon)
                            .font(.system(size: 20))
                        Text(item.title)
                            .foregroundStyle(colorScheme == .dark ? .gray : .black)
                            .fontWeight(.medium)
                    }
                    Divider()
                }
            }
            .padding(.horizontal)

            VStack {
                Text(
                    "Lenny IOS Client v1.00")
                    .foregroundStyle(.gray)
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
            }
            Text(
                "© 2023 Lenny")
                .foregroundStyle(.gray)
                .font(.footnote)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.top, -20)
        }
    }
}

#Preview {
    ProfileView()
}
