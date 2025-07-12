import Foundation

protocol NavigationDestination: Hashable, Equatable {
  var tab: AppTabs { get }
}
