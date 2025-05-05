//
//  TabButtons.swift
//  Sammy
//
//  Created by Khanh Nguyen on 5/5/25.
//
import SwiftUI

// MARK: - CommunityButtons

struct CommunityButtons: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Text(title)
            .foregroundColor(isSelected ? .purple : .gray)
            .bold(isSelected)
            .onTapGesture {
                action()
            }
    }
}

// MARK: - TabOptions

enum TabOptions {
    case myCommunities
    case discover
}
