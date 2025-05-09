import SwiftUI

struct RegisterView: View {
    @State private var viewModel = RegisterViewModel()

    var body: some View {
        VStack(spacing: .paddingLarge) {
            FormField(text: $viewModel.emailText, label: "Email")
            FormField(text: $viewModel.usernameText, label: "Username")
            FormField(text: $viewModel.passwordText, label: "Password")

            if let uiImage = viewModel.captcha?.png.base64ToImage() {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 100)
                    .border(Color.gray, width: 1)
            } else {
                Text("Failed to load CAPTCHA image")
                    .foregroundColor(.red)
            }

            FormField(text: $viewModel.captchaAnswerText, label: "Enter captcha answer")
                .textFieldStyle(.roundedBorder)
                .padding()


            Button(action: viewModel.login, label: {
                Text("Login")
            })
        }
        .task {
            await viewModel.loadCaptcha()
        }
    }
}
