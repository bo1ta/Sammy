import Foundation
import Factory
import SammyData

@Observable
@MainActor
final class LoginViewModel {
    @ObservationIgnored
    @Injected(\.authenticationHandler) private var authenticationHandler

    @ObservationIgnored
    @Injected(\.userStore) private var userStore

    private(set) var isLoading = false

    var usernameOrEmail = ""
    var password = ""

    func login() {
        guard !usernameOrEmail.isEmpty, !password.isEmpty else {
            return
        }

        Task {
            do {
                let person = try await authenticationHandler.login(usernameOrEmail: usernameOrEmail, password: password, twoFactoryAuthToken: nil)
                await userStore.peformPostLogin()
            } catch {
                print(error)
            }
        }
    }
}
