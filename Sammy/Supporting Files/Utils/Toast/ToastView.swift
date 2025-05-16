import SwiftUI

// MARK: - ToastView

public struct ToastView: View {
    var style: Toast.ToastStyle
    var message: String
    var width = CGFloat.infinity

    public var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Image(systemName: style.systemImageName)
                .renderingMode(.template)
                .foregroundStyle(style.backgroundColor)
            Text(message)
                .foregroundStyle(.textPrimary)
                .font(.system(size: .fontSizeSubheadline, weight: .medium))
        }
        .padding()
        .background(Color.secondaryBackground, in: .rect(cornerRadius: .cornerRadiusMedium))
        .overlay {
            RoundedRectangle(cornerRadius: .cornerRadiusMedium)
                .strokeBorder(.gray.opacity(0.5), lineWidth: 0.4)
                .shadow(radius: 3)
                .opacity(0.8)
        }
    }
}

#Preview {
    ToastView(style: .success, message: "Toast is shown")
}
