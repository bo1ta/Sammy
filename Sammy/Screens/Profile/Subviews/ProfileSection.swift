import SwiftUI

struct ProfileSection: View {
    @Environment(\.colorScheme) private var colorScheme
    var body: some View {
        HStack(spacing: 16) {
            Circle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 55, height: 55)
            VStack(alignment: .leading, spacing: 4) {
                Text("u/lemmy_user")
                    .font(.headline)
                    .foregroundStyle(colorScheme == .dark ? .gray : .black)

                Text("4328 karma • Joined Mar 2022")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Spacer()
        }
        .padding(.horizontal, .paddingJumbo)
    }
}

#Preview {
    ProfileSection()
        .padding()
}
