import Foundation
import OSLog

public typealias JSONDictionary = [String: Any]

// MARK: - APIRequest

public struct APIRequest {
    private static let contentType = "application/json"

    public var method: HTTPMethod
    public var route: Route
    public var queryParams: [URLQueryItem]?
    public var body: JSONDictionary?
    public var authToken: String?

    public func asURLRequest() throws -> URLRequest {
        guard var baseURL = APIEndpoint.baseWithRoute(route) else {
            throw APIRequestError.invalidBaseURL
        }

        if let queryParams {
            var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
            components?.queryItems = queryParams

            if let urlWithQueryParams = components?.url {
                baseURL = urlWithQueryParams
            }
        }

        var request = URLRequest(url: baseURL)
        request.httpMethod = method.rawValue

        if let body {
            let data = try makeHTTPBodyForDictionary(body)
            request.httpBody = data
        }

        var headerFields: [String: String] = [
            Constants.HTTPHeaderKey.contentType: APIRequest.contentType,
        ]
        if let authToken {
            headerFields[Constants.HTTPHeaderKey.authorization] = "Bearer \(authToken)"
        }
        request.allHTTPHeaderFields = headerFields

        return request
    }

    private func makeHTTPBodyForDictionary(_ jsonDictionary: JSONDictionary) throws -> Data {
        do {
            return try JSONSerialization.data(withJSONObject: jsonDictionary)
        } catch {
            throw APIRequestError.invalidBody(jsonDictionary, error)
        }
    }
}

// MARK: APIRequest.APIRequestError

extension APIRequest {
    public enum APIRequestError: LocalizedError, @unchecked Sendable {
        case invalidBody(JSONDictionary, Error)
        case invalidBaseURL

        var localizedDescription: String {
            switch self {
            case .invalidBody(let jsonDictionary, let error):
                "Error serializing JSON body \(jsonDictionary). Error: \(error)"
            case .invalidBaseURL:
                "Invalid base URL. Make sure your configuration points to a valid URL."
            }
        }
    }
}
