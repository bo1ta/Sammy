import UIKit

extension UIImageView {
  public func loadGif(name: String, in bundle: Bundle = .main) {
    if let data = NSDataAsset(name: name, bundle: bundle)?.data {
      CGAnimateImageDataWithBlock(data as CFData, nil) { _, cgImage, _ in
        self.image = UIImage(cgImage: cgImage)
      }
    }
  }
}
