import Foundation
import Models
import Networking
import UIKit

@Observable
@MainActor
final class RegisterViewModel {
    private let service: AuthServiceProtocol

    init(service: AuthServiceProtocol = AuthService()) {
        self.service = service
    }

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
            SammyWrapper.showWarning("Inputs are not valid")
            return
        }

        Task {
            SammyWrapper.showLoading()
            defer { SammyWrapper.hideLoading() }

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
        SammyWrapper.showError(message)
    }

    private func showSuccessToast() {
        let toast = Toast(
            style: .success,
            message: "Register completed! Activate your account by clicking the link in your email, then log-in.")
        SammyWrapper.shared.show(toast, autoDismissAfter: 2.0)
    }
}
