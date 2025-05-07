import SwiftUI

// MARK: - RoundedCorner

struct RoundedCorner: Shape {
    var radius: CGFloat = 0
    var corners = UIRectCorner.allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

// MARK: - ProfileButtons

struct ProfileButtons: View {
    @State private var selectedTab = "Profile"
    @Environment(\.colorScheme) private var colorScheme
    var body: some View {
        HStack(spacing: 0) {
            Text("Profile")
                .foregroundStyle(selectedTab == "Edit" ? .gray : .black)
                .frame(maxWidth: .infinity)
                .padding(11)
                .background(
                    selectedTab == "Profile" ? Color
                        .purple : (colorScheme == .dark ? Color.white.opacity(0.1) : Color.black.opacity(0.1)))
                .clipShape(RoundedCorner(radius: 10, corners: [.topLeft, .bottomLeft]))
                .onTapGesture {
                    withAnimation {
                        selectedTab = "Profile"
                    }
                }

            Text("Edit")
                .foregroundStyle(selectedTab == "Edit" ? .black : .gray)
                .frame(maxWidth: .infinity)
                .padding(11)
                .background(
                    selectedTab == "Edit" ? Color
                        .purple : (colorScheme == .dark ? Color.white.opacity(0.1) : Color.black.opacity(0.1)))
                .clipShape(RoundedCorner(radius: 10, corners: [.topRight, .bottomRight]))
                .onTapGesture {
                    withAnimation {
                        selectedTab = "Edit"
                    }
                }
        }
        .padding(.horizontal, .paddingJumbo)
    }
}

// MARK: - ContentView_Previews

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileButtons()
    }
}

// Color.black.opacity(0.1) white
