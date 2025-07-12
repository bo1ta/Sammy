import SwiftUI

// MARK: - LoginView

struct LoginView: View {
  @Environment(\.authNavigator) private var authNavigator: AuthNavigator
  @State private var viewModel = LoginViewModel()

  var destinationOverriden: Bool

  init(destinationOverriden: Bool = false) {
    self.destinationOverriden = destinationOverriden
  }

  var body: some View {
    VStack(spacing: .paddingLarge) {
      Text("Logging into lemmy.world")
        .foregroundStyle(.accent)
        .font(.system(size: .fontSizeCaption, weight: .light))
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, .paddingLarge)

      FormField(text: $viewModel.usernameOrEmail, label: "Username / Email")
      FormField(text: $viewModel.password, label: "Password", isSecureField: true)

      Button(action: viewModel.login, label: {
        Text("Login")
      })
      .buttonStyle(PrimaryButtonStyle())

      HStack {
        Text("Don't have an account?")
          .foregroundStyle(.textPrimary)
          .font(.system(size: .fontSizeCaption, weight: .light))
        Button(action: {
          authNavigator.navigate(to: .register)
        }, label: {
          Text("Register now")
            .font(.system(size: .fontSizeCaption, weight: .semibold))
            .foregroundStyle(.accent)
        })
        .buttonStyle(.plain)
      }
    }
    .frame(maxHeight: .infinity)
    .padding(.horizontal, .paddingLarge)
    .background(Color.primaryGradientBackground)
    .navigationBarBackButtonHidden(destinationOverriden)
  }
}

extension Color {
  static let primaryGradientBackground = LinearGradient(
    colors: [Color.primaryBackground, Color.white],
    startPoint: .top,
    endPoint: .bottom)
}
