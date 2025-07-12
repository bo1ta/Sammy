import SwiftUI

// MARK: - ToastViewModifier

public struct ToastViewModifier: ViewModifier {
  @Binding var toast: Toast?

  public func body(content: Content) -> some View {
    content
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .overlay(
        ZStack {
          if let toast {
            VStack {
              Spacer()
              ToastView(
                style: toast.style,
                message: toast.message,
                width: toast.width)
            }
            .padding(.bottom, 100)
            .transition(.asymmetric(insertion: .push(from: .bottom), removal: .move(edge: .bottom)))
          }
        }
        .animation(.smooth(duration: 0.3), value: toast))
  }
}

extension View {
  public func toastView(toast: Binding<Toast?>) -> some View {
    modifier(ToastViewModifier(toast: toast))
  }
}
