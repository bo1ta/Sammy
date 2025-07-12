import SwiftUI

public struct FormField: View {
  private let text: Binding<String>
  private let label: String?
  private let labelColor: Color
  private let textHint: String?
  private let keyboardType: UIKeyboardType
  private let isSecureField: Bool
  private let imageIcon: Image?
  private let fieldHeight: CGFloat

  public init(
    text: Binding<String>,
    label: String? = nil,
    labelColor: Color = .black,
    textHint: String? = nil,
    keyboardType: UIKeyboardType = .default,
    isSecureField: Bool = false,
    imageIcon: Image? = nil,
    fieldHeight: CGFloat = 45)
  {
    self.text = text
    self.label = label
    self.labelColor = labelColor
    self.textHint = textHint
    self.keyboardType = keyboardType
    self.isSecureField = isSecureField
    self.imageIcon = imageIcon
    self.fieldHeight = fieldHeight
  }

  public var body: some View {
    VStack(alignment: .leading, spacing: .paddingMedium) {
      if let label {
        Text(label)
          .font(.system(size: .fontSizeCaption, weight: .bold))
          .foregroundStyle(Color.textPrimary)
      }

      RoundedRectangle(cornerRadius: .cornerRadiusTiny)
        .fill(.card)
        .shadow(color: .gray.opacity(0.3), radius: 3)
        .frame(maxWidth: .infinity)
        .frame(height: fieldHeight)
        .overlay {
          RoundedRectangle(cornerRadius: .cornerRadiusTiny)
            .strokeBorder(Color.gray.opacity(0.3), lineWidth: 1)
        }
        .overlay {
          HStack {
            if let imageIcon {
              imageIcon
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 20)
            }

            if isSecureField {
              SecureField(text: text, label: {
                if let textHint {
                  Text(textHint)
                    .font(.system(size: .fontSizeCaption, weight: .light))
                    .foregroundStyle(Color.textSecondary)
                }
              })
              .textContentType(.none)
            } else {
              TextField(text: text, label: {
                if let textHint {
                  Text(textHint)
                    .font(.system(size: .fontSizeCaption, weight: .light))
                    .foregroundStyle(Color.textSecondary)
                }
              })
              .foregroundStyle(Color.textPrimary)
            }
          }
          .textContentType(.none)
          .foregroundStyle(.black)
          .textInputAutocapitalization(.never)
          .autocorrectionDisabled()
          .keyboardType(keyboardType)
          .padding(.leading)
        }
    }
  }
}

#Preview {
  FormField(
    text: .constant(""),
    label: "Username",
    labelColor: .accent,
    keyboardType: .decimalPad,
    imageIcon: Image("search-icon"))
}
