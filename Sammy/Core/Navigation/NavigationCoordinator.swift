import Foundation
import OSLog

@Observable
@MainActor
final class NavigationCoordinator {
    private let logger = Logger(subsystem: "com.Sammy", category: "NavigationCoordinator")

    var currentTab = AppTabs.communities

    nonisolated init() {}

}
