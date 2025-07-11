import Domain
import Foundation

@Observable
@MainActor
final class LoginViewModel {
    private let authenticationHandler: AuthenticationHandlerProtocol
    private let userStore: UserStore

    init(
        authenticationHandler: AuthenticationHandlerProtocol = AuthenticationHandler(),
        userStore: UserStore = UserStore.shared)
    {
        self.authenticationHandler = authenticationHandler
        self.userStore = userStore
    }

    var usernameOrEmail = ""
    var password = ""

    func login() {
        guard !usernameOrEmail.isEmpty, !password.isEmpty else {
            SammyWrapper.showInfo("You must fill in both fields")
            return
        }

        Task {
            SammyWrapper.showLoading()
            defer { SammyWrapper.hideLoading() }

            do {
                _ = try await authenticationHandler.login(
                    usernameOrEmail: usernameOrEmail,
                    password: password,
                    twoFactoryAuthToken: nil)
                await userStore.peformPostLogin()
            } catch {
                SammyWrapper.showError(error.localizedDescription)
            }
        }
    }
}
