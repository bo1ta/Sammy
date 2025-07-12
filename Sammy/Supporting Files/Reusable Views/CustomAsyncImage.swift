import Networking
import SwiftUI

struct CustomAsyncImage<Content: View, Placeholder: View>: View {
  @State private var imageData: Data?
  private let url: URL?
  private let content: (Image) -> Content
  private let placeholder: () -> Placeholder

  init(
    url: URL?,
    @ViewBuilder content: @escaping (Image) -> Content,
    @ViewBuilder placeholder: @escaping () -> Placeholder)
  {
    self.url = url
    self.content = content
    self.placeholder = placeholder
  }

  var body: some View {
    Group {
      if let imageData, let uiImage = UIImage(data: imageData) {
        content(Image(uiImage: uiImage))
      } else {
        placeholder()
          .task {
            await loadImage()
          }
      }
    }
  }

  private func loadImage() async {
    guard let url else {
      return
    }

    var request = URLRequest(url: url)
    request.setValue(APIRequest.userAgent, forHTTPHeaderField: "User-Agent")

    do {
      let (data, _) = try await URLSession.shared.data(for: request)
      self.imageData = data
    } catch {
      print(error)
    }
  }
}
