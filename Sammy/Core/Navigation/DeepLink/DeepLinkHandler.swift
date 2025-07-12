//
//  DeepLinkHandler.swift
//  LifeCoach
//
//  Created by Alexandru Solomon on 12.06.2025.
//

import Foundation

// MARK: - DeepLinkHandler

enum DeepLinkHandler {
  private static let supportedDeepLinks: [String: any DestinationProducingDeepLink.Type] = [
    PostDetailDeepLink.host: PostDetailDeepLink.self,
  ]

  static func parseDeepLink(_ url: URL) -> DestinationProducingDeepLink? {
    guard
      let host = URLComponents(url: url, resolvingAgainstBaseURL: false)?.host,
      let handlerType = supportedDeepLinks[host]
    else {
      return nil
    }
    return handlerType.init()
  }

  static func navigationTypeForURL(_ url: URL) async -> NavigationType? {
    guard
      let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
      let deepLink = parseDeepLink(url)
    else {
      return nil
    }
    return await deepLink.navigationDestinations(from: components)
  }
}
