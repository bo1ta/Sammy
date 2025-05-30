import SwiftUI

struct ProfileView: View {
    @State private var selectedTab = "Posts"
    @State var viewModel = ProfileViewModel()
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
                            .foregroundStyle(Color.textPrimary)
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
                    .font(.system(size: .fontSizeCaption))
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
            }
            Text(
                "© 2023 Lenny")
                .foregroundStyle(.gray)
                .font(.system(size: .fontSizeCaption))
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.top, -20)
        }
    }
}

#Preview {
    ProfileView()
}
