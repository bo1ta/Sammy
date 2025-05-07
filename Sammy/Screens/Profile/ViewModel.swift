import SwiftUI

// MARK: - MenuItem

struct MenuItem: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
}

// MARK: - ProfileViewModel

class ProfileViewModel {
    var selectedTab = "Posts"
    @State var selectedButton = "Profile"
    let tabNames: [String] = ["Posts", "Comments", "Saved"]
    let menuItems: [MenuItem] = [
        MenuItem(icon: "person.circle", title: "My Account"),
        MenuItem(icon: "square.and.arrow.down", title: "Saved"),
        MenuItem(icon: "clock", title: "History"),
        MenuItem(icon: "gear", title: "Settings"),
        MenuItem(icon: "questionmark.circle", title: "Help & Support"),
        MenuItem(icon: "rectangle.portrait.and.arrow.right", title: "Log Out"),
    ]
}
