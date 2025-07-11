import SwiftUI

struct GIFImage: UIViewRepresentable {
    var name: String

    init(_ name: String) {
        self.name = name
    }

    func makeUIView(context _: Context) -> UIImageView {
        let imageView = UIImageView()
        imageView.loadGif(name: name)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }

    func updateUIView(_ uiView: UIImageView, context _: Context) {
        uiView.loadGif(name: name)
    }
}
