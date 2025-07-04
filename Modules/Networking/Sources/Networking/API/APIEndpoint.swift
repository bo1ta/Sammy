import Foundation

public enum APIEndpoint {
    /// hard coded for now. should be loaded from the environment or set as a custom override from the app settings
    private static let baseURLString = "https://lemmy.ml/api/v3"

    static func baseWithRoute(_ route: Route) -> URL? {
        URL(string: Self.baseURLString + route.path)
    }
}
