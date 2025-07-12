import Domain
import SwiftUI

// MARK: - SplashDestinations

enum SplashDestinations {
  case login
  case register
}

// MARK: - AuthNavigator

@Observable
@MainActor
final class AuthNavigator: Navigator {
  var path: [SplashDestinations] = []
  var showVerifyEmailSheet = false

  nonisolated init() { }

  func navigate(to destination: SplashDestinations) {
    path.append(destination)
  }

  func pop() {
    if !path.isEmpty {
      path.removeLast()
    }
  }

  func popToRoot() {
    path = []
  }
}

// MARK: - SplashView

struct SplashView: View {
  @State private var navigator = AuthNavigator()
  var overrideDestination: SplashDestinations?

  init(overrideDestination: SplashDestinations? = nil) {
    self.overrideDestination = overrideDestination
    if let overrideDestination {
      navigator.navigate(to: overrideDestination)
    }
  }

  var body: some View {
    NavigationStack(path: $navigator.path) {
      VStack(spacing: .paddingLarge) {
        Circle()
          .fill(Color.accent)
          .frame(height: .iconSizeJumbo)

        Text("Welcome to Sammy")
          .foregroundStyle(.textPrimary)
          .font(.system(size: .fontSizeLargeTitle, weight: .bold, design: .rounded))
        Text("Join the decentralized discussion platform where communities thrive")
          .foregroundStyle(.textSecondary)
          .font(.system(size: .fontSizeSubheadline, weight: .light))

        Button("Get Started") {
          navigator.navigate(to: .login)
        }
        .buttonStyle(PrimaryButtonStyle())

        Button("Browse Communities") {
          UserStore.shared.performAnonymousLogin()
        }
        .buttonStyle(PrimaryButtonStyle())
        .opacity(overrideDestination != nil ? 0 : 1)

        Text("By continuing, you agree to our Terms of Service and Privacy Policy")
          .foregroundStyle(.textSecondary)
          .font(.system(size: .fontSizeSubheadline, weight: .light))
          .multilineTextAlignment(.center)
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .padding(.horizontal, .paddingLarge)
      .background(Color.primaryBackground)
      .navigationDestination(for: SplashDestinations.self, destination: { destination in
        switch destination {
        case .login:
          LoginView(destinationOverriden: overrideDestination != nil)
            .environment(\.authNavigator, navigator)

        case .register:
          RegisterView(destinationOverriden: overrideDestination != nil)
            .environment(\.authNavigator, navigator)
        }
      })
    }
  }
}
