import SwiftUI

struct LoadingOverlayView: View {
    @State private var isAnimating = false

    var body: some View {
        VStack(alignment: .center, spacing: .paddingLarge) {
            GIFImage("Hourglass")
                .frame(width: .iconSizeLarge, height: .iconSizeLarge)

            HStack {
                Text("Loading")
                    .foregroundStyle(.textPrimary)
                    .font(.system(size: .fontSizeTitle, weight: .bold))
                animatedPeriods
            }
            .animation(.easeInOut.delay(0.3).repeatForever(autoreverses: true), value: isAnimating)
        }
        .onAppear {
            isAnimating = true
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.primaryBackground.opacity(0.8))
        .ignoresSafeArea()
    }

    private var animatedPeriods: some View {
        HStack {
            ForEach(0..<3) { _ in
                Text(".")
                    .foregroundStyle(.textPrimary)
                    .font(.system(size: .fontSizeTitle, weight: .bold))
                    .opacity(isAnimating ? 1 : 0)
            }
        }
    }
}
