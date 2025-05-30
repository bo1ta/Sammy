import SwiftUI

	 // MARK: - RoundedCorner
extension ProfileButtons {
	 private struct CustomRoundedCorner: Shape {
			var radius: CGFloat = 0
			var corners = UIRectCorner.allCorners

			func path(in rect: CGRect) -> Path {
				 let path = UIBezierPath(
						roundedRect: rect,
						byRoundingCorners: corners,
						cornerRadii: CGSize(width: radius, height: radius)
				 )
				 return Path(path.cgPath)
			}
	 }
	 enum Tab: String, CaseIterable {
			case profile = "Profile"
			case edit = "Edit"
	 }
}


	 // MARK: - ProfileButtons

struct ProfileButtons: View {
	 @State private var selectedTab: Tab = .profile
	 @Environment(\.colorScheme) private var colorScheme
	 var body: some View {
			HStack(spacing: 0) {
				 Text("Profile")
						.foregroundStyle(selectedTab == .edit ? .gray : .black)
						.frame(maxWidth: .infinity)
						.padding(11)
						.background(
							 selectedTab == .profile ? Color
									.purple : (Color.primaryBackground))
						.clipShape(CustomRoundedCorner(radius: 10, corners: [.topLeft, .bottomLeft]))
						.onTapGesture {
							 withAnimation {
									selectedTab = .profile
							 }
						}
				 Text("Edit")
						.foregroundStyle(selectedTab == .edit ? .black : .gray)
						.frame(maxWidth: .infinity)
						.padding(11)
						.background(
							 selectedTab == .edit ? Color
									.purple : (Color.primaryBackground))
						.clipShape(CustomRoundedCorner(radius: 10, corners: [.topRight, .bottomRight]))
						.onTapGesture {
							 withAnimation {
									selectedTab = .edit
							 }
						}
			}
			.padding(.horizontal, .paddingJumbo)
	 }
}
	 // MARK: - ContentView_Previews
#Preview {
	 ProfileButtons()
}
