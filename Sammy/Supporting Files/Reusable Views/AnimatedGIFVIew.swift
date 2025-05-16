import SwiftUI
import SwiftyGif

struct AnimatedGIFView: UIViewRepresentable {
    var url: URL

    func makeUIView(context _: Context) -> UIImageView {
        let imageView = UIImageView(gifURL: self.url)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }

    func updateUIView(_ uiView: UIImageView, context _: Context) {
        uiView.setGifFromURL(self.url)
    }
}
