import Factory
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
    @Injected(\.userStore) private var userStore: UserStore

    @State private var navigator = AuthNavigator()

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
                    userStore.performAnonymousLogin()
                }
                .buttonStyle(PrimaryButtonStyle())

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
                    LoginView()
                        .environment(\.authNavigator, navigator)

                case .register:
                    RegisterView()
                        .environment(\.authNavigator, navigator)
                }
            })
        }
    }
}
