//
//  SearchBar.swift
//  Sammy
//
//  Created by Khanh Nguyen on 5/5/25.
//
import SwiftUI

struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        TextField("Search", text: $text)
            .padding(.horizontal, .paddingJumbo)
            .padding(.vertical, .paddingSmall)
            .overlay(
                RoundedRectangle(cornerRadius: .cornerRadiusSmall)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1))
            .font(.system(size: .fontSizeBody, weight: .regular, design: .rounded))
            .overlay(
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray.opacity(0.6))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, .paddingMedium),
                alignment: .leading)
            .padding(.horizontal, .screenEdgePadding)
            .padding(.top, .paddingExtraLarge)
    }
}
