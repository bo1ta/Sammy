//
//  AvatarImage.swift
//  Sammy
//
//  Created by Alexandru Solomon on 12.07.2025.
//

import SwiftUI

struct AvatarImage: View {
  var avatarURL: URL?

  var body: some View {
    CustomAsyncImage(
      url: avatarURL,
      content: { image in
        image
          .resizable()
          .scaledToFit()
          .frame(height: 30)
          .clipShape(Circle())
      }, placeholder: {
        Circle()
          .frame(height: 30)
      })
  }
}
