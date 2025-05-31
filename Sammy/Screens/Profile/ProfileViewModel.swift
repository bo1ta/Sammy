import SwiftUI
import Factory
import SammyData
import Models
import OSLog

@MainActor
@Observable
class ProfileViewModel {

    // MARK: - Dependencies

    @ObservationIgnored
    @Injected(\.loadingManager) private var loadingManager: LoadingManager

    @ObservationIgnored
    @Injected(\.toastManager) private var toastManager: ToastManagerProtocol

    @ObservationIgnored
    @Injected(\.userRepository) private var userRepository: UserRepositoryProtocol

    @ObservationIgnored
    @Injected(\.userStore) private var userStore: UserStore

    private let logger = Logger(subsystem: "com.Sammy", category: "ProfileViewModel")

    // MARK: - Observed Properties

    private(set) var localUser: LocalUser?

    var selectedTab = ProfileTabs.posts
    var selectedAction = ProfileActions.profile

    // MARK: - Public methods

    func loadData() async {
        loadingManager.showLoading()
        defer { loadingManager.hideLoading() }

        do {
            localUser = try await userRepository.getLocalUser()
        } catch {
            logger.error("Error loading local user data. Error: \(error)")
            toastManager.showError(MessageConstants.genericErrorMessage)
        }
    }
}
