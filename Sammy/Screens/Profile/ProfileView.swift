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
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    .task {
      await viewModel.loadData()
    }
  }
}

// MARK: - Subviews

extension ProfileView {

  private var menuItems: some View {
    VStack(spacing: 0) {
      ForEach(Array(ProfileMenuItems.allCases.enumerated()), id: \.element) { index, item in
        HStack(spacing: .paddingMedium) {
          Image(systemName: item.systemImageName)
            .resizable()
            .scaledToFit()
            .frame(width: .iconSizeSmall, height: .iconSizeSmall)
            .foregroundStyle(.textPrimary)

          Text(item.title)
            .font(.system(size: .fontSizeBody))
            .foregroundStyle(.textPrimary)
        }
        .padding(.horizontal, .paddingMedium)
        .padding(.vertical, .paddingSmall)
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
        .onTapGesture {
          viewModel.handleMenuItem(item)
        }

        if index < ProfileMenuItems.allCases.count - 1 {
          Divider()
            .background(Color.gray.opacity(0.3))
        }
      }
    }
  }

  private var headerSection: some View {
    HStack(spacing: 16) {
      Circle()
        .fill(Color.gray.opacity(0.3))
        .frame(width: 55, height: 55)
      VStack(alignment: .leading, spacing: 4) {
        Text(viewModel.localUser?.personAttributes.userTitle ?? "u/lemmy_user")
          .font(.system(size: .fontSizeSubheadline, weight: .semibold))
          .foregroundStyle(.textPrimary)

        Text("4328 karma • Joined Mar 2022")
          .font(.subheadline)
          .foregroundColor(.textSecondary)
      }
    }
    .padding(.horizontal, .paddingJumbo)
  }

  private var headerActionButtons: some View {
    HStack(spacing: 0) {
      ForEach(ProfileActions.allCases) { action in
        let cornerRadii: RectangleCornerRadii = action == .edit
          ? .init(
            bottomTrailing: .cornerRadiusSmall,
            topTrailing: .cornerRadiusSmall)
          : .init(topLeading: .cornerRadiusSmall, bottomLeading: .cornerRadiusSmall)

        Text(action.title)
          .font(.system(size: .fontSizeCaption))
          .foregroundStyle(.textPrimary)
          .frame(maxWidth: .infinity)
          .padding(.paddingMedium)
          .background(
            viewModel.selectedAction == action
              ? Color
                .accentColor
              : Color.primaryBackground, in: .rect(cornerRadii: cornerRadii))
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
}

#Preview {
  ProfileView()
}
