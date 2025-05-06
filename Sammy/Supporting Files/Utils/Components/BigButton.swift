import SwiftUI

struct BigButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(
            action: action,
            label: {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.purple)
                    .cornerRadius(10)
            })
            .padding(.horizontal)
    }
}
