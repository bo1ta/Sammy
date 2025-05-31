import SwiftUI

@MainActor
@Observable
class ProfileViewModel {
    var selectedTab = ProfileTabs.posts
    var selectedAction = ProfileActions.edit
    var selectedButton = "Profile"
}
