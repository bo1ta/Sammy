import SwiftUI

struct AsyncImageView: View {
	 let url: URL?

	 var body: some View {
			Group {
				 AsyncImage(url: url) { phase in
						switch phase {
						case .empty:
									ProgressView()
						case .success(let image):
									image
										 .resizable()
										 .scaledToFit()
										 .frame(width: .iconSizeJumbo, height: .iconSizeJumbo)
										 .clipShape(Circle())
						case .failure:
									Image(systemName: "exclamationmark.triangle")
										 .resizable()
										 .scaledToFit()
										 .frame(width: .iconSizeLarge, height: .iconSizeLarge)
						@unknown default:
									EmptyView()
						}
				 }
			}
	 }
}
