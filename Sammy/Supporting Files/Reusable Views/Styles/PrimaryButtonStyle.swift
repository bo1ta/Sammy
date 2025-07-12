import SwiftUI

public struct PrimaryButtonStyle: ButtonStyle {
  @Environment(\.isEnabled) private var isEnabled

  public func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .foregroundStyle(isEnabled ? .white : .white.opacity(0.7))
      .font(.system(size: .fontSizeBody, weight: .medium))
      .frame(maxWidth: .infinity)
      .padding(.paddingLarge)
      .background(Color.accentColor, in: RoundedRectangle(cornerRadius: .cornerRadiusTiny))
      .saturation(isEnabled ? 1 : 0.9)
  }
}
