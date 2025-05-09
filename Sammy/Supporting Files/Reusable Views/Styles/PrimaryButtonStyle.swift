import SwiftUI

public struct PrimaryButtonStyle: ButtonStyle {
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(.white)
            .font(.system(size: .fontSizeBody, weight: .medium))
            .frame(maxWidth: .infinity)
            .padding(.paddingLarge)
            .background(Color.accentColor, in: RoundedRectangle(cornerRadius: .cornerRadiusTiny))
    }
}
