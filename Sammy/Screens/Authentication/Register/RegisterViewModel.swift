import Factory
import Foundation
import Models
import Networking
import UIKit

@Observable
@MainActor
final class RegisterViewModel {

    // MARK: - Dependencies

    @ObservationIgnored
    @Injected(\.authService) private var service: AuthServiceProtocol

    @ObservationIgnored
    @Injected(\.toastManager) private var toastManager: ToastManagerProtocol

    @ObservationIgnored
    @Injected(\.loadingManager) private var loadingManager: LoadingManager

    // MARK: - Observed properties

    var emailText = ""
    var usernameText = ""
    var passwordText = ""
    var captchaAnswerText = ""

    private(set) var isCompleted = false
    private(set) var captcha: Captcha?
    private(set) var isLoadingCaptcha = false
    private(set) var isSubmitting = false

    var isFormValid: Bool {
        !usernameText.isEmpty &&
            !passwordText.isEmpty &&
            !emailText.isEmpty &&
            !captchaAnswerText.isEmpty &&
            captcha != nil
    }

    // MARK: - Public methods

    func loadCaptcha() async {
        isLoadingCaptcha = true
        defer { isLoadingCaptcha = false }

        do {
            captcha = try await service.getCaptcha()
        } catch {
            print(error)
            showErrorToast(message: error.localizedDescription)
        }
    }

    func login() {
        guard isFormValid, let captcha else {
            toastManager.showWarning("Inputs are not valid")
            return
        }

        Task {
            loadingManager.showLoading()
            defer { loadingManager.hideLoading() }

            do {
                _ = try await service.register(
                    username: usernameText,
                    password: passwordText,
                    showNSFW: false,
                    email: emailText,
                    captchaUUID: captcha.uuid,
                    captchaResponse: captchaAnswerText,
                    honeypot: nil,
                    answer: "Yes, I agree")

                showSuccessToast()
                isCompleted = true
            } catch let error as APIClientError {
                showErrorToast(message: error.localizedDescription)
                await loadCaptcha()
            } catch {
                showErrorToast(message: "Something went wrong. Please try again later.")
            }
        }
    }

    // MARK: - Private helpers

    private func showErrorToast(message: String) {
        toastManager.showError(message)
    }

    private func showSuccessToast() {
        let toast = Toast(
            style: .success,
            message: "Register completed! Activate your account by clicking the link in your email, then log-in.")
        toastManager.show(toast, autoDismissAfter: 2.0)
    }
}
