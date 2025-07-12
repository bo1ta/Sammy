//
//  PostAuthorView.swift
//  Sammy
//
//  Created by Alexandru Solomon on 12.07.2025.
//

import Models
import SwiftUI

struct PostAuthorView: View {
  let post: Post

  var body: some View {
    HStack {
      AvatarImage(avatarURL: post.creator.avatarURL)

      VStack(alignment: .leading, spacing: 0) {
        Button(action: { }, label: {
          Text("c/\(post.communityAttributes.name)")
            .font(.system(size: .fontSizeCaption, weight: .medium))
            .foregroundStyle(Color.accentColor)
        })
        .buttonStyle(.plain)
        .padding(.trailing, .paddingMedium)

        HStack {
          Text("\(post.creator.userTitle)")
            .font(.system(size: .fontSizeCaption, weight: .light))
            .foregroundStyle(.textSecondary)
          TinyCircleSeparator()
          Text(DateHelper.relativeTimeFromString(post.attributes.published))
            .font(.system(size: .fontSizeCaption, weight: .light))
            .foregroundStyle(.textSecondary)
        }
      }
    }
  }
}
