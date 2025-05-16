import Foundation
import SwiftUI

// MARK: - Toast

public struct Toast: Equatable, Sendable {
    public var style: ToastStyle
    public var message: String
    public var width: Double

    public init(style: ToastStyle, message: String, width: Double = .infinity) {
        self.style = style
        self.message = message
        self.width = width
    }

    public static func warning(_ message: String) -> Toast {
        Toast(style: .warning, message: message)
    }

    public static func error(_ message: String) -> Toast {
        Toast(style: .error, message: message)
    }

    public static func success(_ message: String) -> Toast {
        Toast(style: .success, message: message)
    }

    public static func info(_ message: String) -> Toast {
        Toast(style: .info, message: message)
    }
}

// MARK: Toast.ToastStyle

extension Toast {
    public enum ToastStyle: Sendable {
        case success, info, warning, error

        var borderColor: Color {
            switch self {
            case .success: Color.green
            case .info: Color.blue
            case .warning: Color.orange
            case .error: Color.red
            }
        }

        var backgroundColor: Color {
            switch self {
            case .success: Color.green.opacity(0.7)
            case .info: Color.gray
            case .warning: Color.yellow
            case .error: Color.red
            }
        }

        var systemImageName: String {
            switch self {
            case .success: "checkmark.circle.fill"
            case .info: "info.circle.fill"
            case .warning: "exclamationmark.triangle.fill"
            case .error: "xmark.circle.fill"
            }
        }
    }
}
