import SwiftUI

// MARK: - ProfileView

struct ProfileView: View {
    @State var viewModel = ProfileViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: .paddingExtraLarge) {
            headerSection
            headerActionButtons
            profileTabs
            menuItems
            appInfoSection
        }
    }

}

// MARK: - Subviews

extension ProfileView {

    private var appInfoSection: some View {
        VStack {
            Text(
                "Sammy IOS Client v1.00")
            .foregroundStyle(.gray)
            .font(.system(size: .fontSizeCaption))
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)

            Text(
                "© 2025 Sammy")
            .foregroundStyle(.gray)
            .font(.system(size: .fontSizeCaption))
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
            .padding(.top, .paddingMedium)
        }
    }

    private var menuItems: some View {
        VStack {
            ForEach(ProfileMenuItems.allCases) { item in
                HStack(spacing: .paddingMedium) {
                    Image(systemName: item.systemImageName)
                        .font(.system(size: 20))
                    Text(item.title)
                        .foregroundStyle(Color.textPrimary)
                        .fontWeight(.medium)
                }
                Divider()
            }
        }
    }

    private var headerSection: some View {
        HStack(spacing: 16) {
            Circle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 55, height: 55)
            VStack(alignment: .leading, spacing: 4) {
                Text("u/lemmy_user")
                    .font(.system(size: .fontSizeSubheadline, weight: .semibold))
                    .foregroundStyle(.textPrimary)

                Text("4328 karma • Joined Mar 2022")
                    .font(.subheadline)
                    .foregroundColor(.textSecondary)
            }

            Spacer()
        }
        .padding(.horizontal, .paddingJumbo)
    }

    private var headerActionButtons: some View {
        HStack(spacing: 0) {
            ForEach(ProfileActions.allCases) { action in
                Text(action.title)
                    .foregroundStyle(viewModel.selectedAction == action ? .gray : .black)
                    .frame(maxWidth: .infinity)
                    .padding(.paddingMedium)
                    .background(
                        viewModel.selectedAction == action ? Color
                            .accentColor : Color.primaryBackground, in: .rect(cornerRadii: .init(topLeading: .cornerRadiusSmall, bottomLeading: .cornerRadiusSmall)))
                    .onTapGesture {
                        withAnimation {
                            viewModel.selectedAction = action
                        }
                    }

            }
        }
        .padding(.horizontal, .paddingJumbo)
    }

    private var profileTabs: some View {
        HStack {
            ForEach(ProfileTabs.allCases) { tab in
                VStack {
                    Text(tab.title)
                        .foregroundColor(viewModel.selectedTab == tab ? .purple : .gray)
                        .fontWeight(viewModel.selectedTab == tab ? .semibold : .regular)
                    Rectangle()
                        .fill(viewModel.selectedTab == tab ? Color.purple : Color.clear)
                        .frame(height: 2)
                }
                .onTapGesture {
                    withAnimation {
                        viewModel.selectedTab = tab
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

#Preview {
    ProfileView()
}
