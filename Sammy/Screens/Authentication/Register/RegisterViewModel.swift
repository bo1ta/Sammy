import Foundation
import Factory
import Networking
import Models
import UIKit

@Observable
@MainActor
final class RegisterViewModel {
    @ObservationIgnored
    @Injected(\.authService) private var service: AuthServiceProtocol

    var emailText = ""
    var usernameText = ""
    var passwordText = ""
    var captchaAnswerText = ""
    var showVerifyEmail = false

    private(set) var captcha: Captcha?

    func loadCaptcha() async {
        do {
            captcha = try await service.getCaptcha()
        } catch {
            print(error)
        }
    }

    func login() {
        guard !usernameText.isEmpty, !passwordText.isEmpty, !emailText.isEmpty, let captcha else {
            return
        }

        Task {
            do {
                let response = try await service.register(username: usernameText, password: passwordText, showNSFW: false, email: emailText, captchaUUID: captcha.uuid, captchaResponse: captchaAnswerText, honeypot: nil, answer: "Yes, I agree")
                showVerifyEmail = true
                print(response)
            } catch {
                print(error.localizedDescription)
                await loadCaptcha()
            }
        }
    }
}
