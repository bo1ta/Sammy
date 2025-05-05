//
//  Discover.swift
//  Sammy
//
//  Created by Khanh Nguyen on 5/5/25.
//

import SwiftUI

struct DiscoverView: View {
    var viewModel: CommunitiesViewModel

    var body: some View {
        Text("No communities loaded.")
            .foregroundColor(.gray)
            .padding(.screenEdgePadding)
    }
}
