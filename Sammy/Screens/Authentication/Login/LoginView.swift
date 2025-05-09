import SwiftUI

struct LoginView: View {
    @State private var viewModel = LoginViewModel()

    var body: some View {
        VStack(spacing: .paddingLarge) {
            FormField(text: $viewModel.usernameOrEmail, label: "Username / Email")
            FormField(text: $viewModel.password, label: "Password", isSecureField: true)

            Button(action: viewModel.login, label: {
                Text("Login")
            })
            .buttonStyle(PrimaryButtonStyle())

            HStack {
                Text("Don't have an account?")
                    .foregroundStyle(.textPrimary)
                Button(action: {}, label: {
                    Text("Register")
                        .font(.system(size: .fontSizeBody, weight: .semibold))
                        .foregroundStyle(.accent)
                })
                .buttonStyle(.plain)
            }
        }
        .frame(maxHeight: .infinity)
        .padding(.horizontal, .paddingLarge)
        .background(Color.red)
    }
}
