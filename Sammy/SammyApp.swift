import SwiftUI

@main
struct SammyApp: App {
    @State private var showWelcome = true // State to toggle WelcomeView

    var body: some Scene {
        WindowGroup {
            if showWelcome {
                WelcomeView(isPresented: $showWelcome)
            } else {
                AppTabView()
            }
        }
    }
}
