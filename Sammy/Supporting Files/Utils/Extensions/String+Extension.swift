import UIKit

extension String {
  func base64ToImage() -> UIImage? {
    guard let imageData = Data(base64Encoded: self) else {
      print("Failed to decode base64 string: \(self.prefix(20))...")
      return nil
    }

    guard let image = UIImage(data: imageData) else {
      print("Failed to create UIImage from data")
      return nil
    }

    return image
  }
}
