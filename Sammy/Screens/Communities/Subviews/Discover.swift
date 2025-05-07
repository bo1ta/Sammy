import SwiftUI

struct DiscoverView: View {
    var viewModel: CommunitiesViewModel

    var body: some View {
        Text("No communities loaded.")
            .foregroundColor(.gray)
            .padding(.screenEdgePadding)
    }
}
