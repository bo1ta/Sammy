import SwiftUI

struct PostImage: View {
    var imageURL: URL
    var height: CGFloat

    init(imageURL: URL, height: CGFloat = 200) {
        self.imageURL = imageURL
        self.height = height
    }

    var body: some View {
        AsyncImage(url: imageURL) { imagePhase in
            switch imagePhase {
            case .empty:
                emptyImage

            case .success(let image):
                image.resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .frame(height: height)

            case .failure(let error):
                emptyImage
                    .onAppear {
                        print(error.localizedDescription)
                    }

            @unknown default:
                fatalError("Unknown default")
            }
        }
    }

    private var emptyImage: some View {
        Color.white
            .frame(maxWidth: .infinity)
            .frame(height: height)
    }
}
