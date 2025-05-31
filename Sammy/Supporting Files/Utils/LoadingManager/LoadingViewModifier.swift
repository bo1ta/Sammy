import SwiftUI

struct LoadingViewModifier: ViewModifier {
    var isLoading: Bool

    public func body(content: Content) -> some View {
        content.overlay {
            if isLoading {
                LoadingOverlayView()
                    .transition(.opacity)
            }
        }
    }
}

extension View {
    func loadingView(isLoading: Bool) -> some View {
        modifier(LoadingViewModifier(isLoading: isLoading))
    }
}
