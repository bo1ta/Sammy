import SwiftUI

struct WelcomeView: View {
    @Binding var isPresented: Bool
    var body: some View {
        VStack(spacing: .paddingExtraLarge) {
            Image(systemName: "accessibility.fill")
                .resizable()
                .frame(width: 90, height: 90)
                .foregroundColor(Color.purple) // Placeholder for real profile later

            Text("Welcome to Sammy")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Join the decentralized discussion platform where communities thrive")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundStyle(.gray)

            BigButton(title: "Get Started") {
                isPresented = false
                print("Hello world")
            }

            Text(
                "By continuing, you agree to our [Terms of Service](YourTermsOfServiceURL) and [Privacy Policy](YourPrivacyPolicyURL)")
                .foregroundStyle(.gray)
                .font(.footnote)
                .multilineTextAlignment(.center)

            Spacer()
        }
        .padding()
    }
}
