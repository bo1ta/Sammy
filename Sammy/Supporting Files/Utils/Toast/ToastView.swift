import SwiftUI

// MARK: - ToastView

public struct ToastView: View {
  var style: Toast.ToastStyle
  var message: String
  var width = CGFloat.infinity

  public var body: some View {
    RoundedRectangle(cornerRadius: 8)
      .frame(maxWidth: .infinity)
      .frame(height: 40)
      .shadow(radius: 3)
      .padding(.horizontal, 16)
      .foregroundStyle(.white)
      .overlay {
        RoundedRectangle(cornerRadius: 8)
          .stroke(.white)
          .shadow(radius: 3)
          .opacity(0.8)
          .padding(.horizontal, 16)
      }
      .overlay {
        HStack(alignment: .center, spacing: 12) {
          Image(systemName: style.systemImageName)
            .renderingMode(.template)
            .foregroundStyle(style.backgroundColor)
          Text(message)
            .foregroundStyle(.black)
        }
      }
  }
}

#Preview {
  ToastView(style: .success, message: "Toast is shown")
}
