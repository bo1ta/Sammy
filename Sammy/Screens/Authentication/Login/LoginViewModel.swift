import Factory
import Foundation
import SammyData

@Observable
@MainActor
final class LoginViewModel {

    // MARK: Dependencies

    @ObservationIgnored
    @Injected(\.authenticationHandler) private var authenticationHandler: AuthenticationHandlerProtocol

    @ObservationIgnored
    @Injected(\.userStore) private var userStore: UserStore

    @ObservationIgnored
    @Injected(\.toastManager) private var toastManager: ToastManagerProtocol

    @ObservationIgnored
    @Injected(\.loadingManager) private var loadingManager: LoadingManager

    // MARK: Observed properties

    var usernameOrEmail = ""
    var password = ""

    // MARK: Public methods

    func login() {
        guard !usernameOrEmail.isEmpty, !password.isEmpty else {
            return
        }

        Task {
            loadingManager.showLoading()
            defer { loadingManager.hideLoading() }

            do {
                _ = try await authenticationHandler.login(
                    usernameOrEmail: usernameOrEmail,
                    password: password,
                    twoFactoryAuthToken: nil)
                await userStore.peformPostLogin()
            } catch {
                toastManager.showError(error.localizedDescription)
            }
        }
    }
}
