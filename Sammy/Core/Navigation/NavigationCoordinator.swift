import Foundation
import OSLog

@Observable
@MainActor
final class NavigationCoordinator {
    var currentTab = AppTabs.communities

    nonisolated init() { }

}
