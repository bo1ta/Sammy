import SwiftUI

struct RegisterView: View {
  @Environment(\.authNavigator) private var authNavigator: AuthNavigator
  @State private var viewModel = RegisterViewModel()

  var destinationOverriden: Bool

  init(destinationOverriden: Bool = false) {
    self.destinationOverriden = destinationOverriden
  }

  var body: some View {
    ScrollView {
      VStack(spacing: .paddingLarge) {
        FormField(text: $viewModel.emailText, label: "Email")
        FormField(text: $viewModel.usernameText, label: "Username")
        FormField(text: $viewModel.passwordText, label: "Password", isSecureField: true)
        FormField(text: $viewModel.captchaAnswerText, label: "Enter captcha answer")
        captchaView
      }
      .padding(.top, .paddingLarge)
    }
    .scrollIndicators(.hidden)
    .task {
      await viewModel.loadCaptcha()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .safeAreaInset(edge: .bottom, content: {
      Button(action: viewModel.login, label: {
        Text("Register")
      })
      .buttonStyle(PrimaryButtonStyle())
      .disabled(!viewModel.isFormValid)
    })
    .padding(.horizontal, .paddingLarge)
    .background(Color.primaryGradientBackground)
    .onChange(of: viewModel.isCompleted) { _, isCompleted in
      if isCompleted {
        authNavigator.pop()
      }
    }
    .navigationBarBackButtonHidden(destinationOverriden)
  }

  @ViewBuilder
  private var captchaView: some View {
    if viewModel.isLoadingCaptcha {
      ProgressView()
    } else if let uiImage = viewModel.captcha?.png.base64ToImage() {
      Image(uiImage: uiImage)
        .resizable()
        .scaledToFit()
        .frame(width: 200, height: 100)
        .border(Color.gray, width: 1)
    } else {
      Text("Failed to load CAPTCHA image")
        .foregroundColor(.red)
    }
  }
}
