import SwiftUI

/// Tiny circle used as a separator between various UI text
///
struct TinyCircleSeparator: View {
    var body: some View {
        Circle()
            .fill(Color.textPrimary)
            .frame(height: 2)
    }
}
