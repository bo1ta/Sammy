import Networking
import SwiftUI

struct PostImage: View {
    var imageURL: URL
    var height: CGFloat

    init(imageURL: URL, height: CGFloat = 200) {
        self.imageURL = imageURL
        self.height = height
    }

    var body: some View {
        CustomAsyncImage(
            url: imageURL,
            content: { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
            },
            placeholder: {
                ProgressView()
            })
    }
}
