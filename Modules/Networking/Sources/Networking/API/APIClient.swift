import Foundation

// MARK: - APIClient

public struct APIClient: APIClientProvider {
    private let session: URLSession

    public init(session: URLSession = .shared) {
        self.session = session
    }

    public func dispatch(_ request: APIRequest) async throws -> Data {
        let urlRequest = try request.asURLRequest()
        let (data, response) = try await session.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIClientError.invalidServerResponse
        }

        guard 200..<300 ~= httpResponse.statusCode else {
            if let decodedError = try? LemmyError.createFrom(data) {
                throw APIClientError.serverError(message: decodedError.error)
            } else {
                throw APIClientError.badServerResponse(httpResponse.statusCode)
            }
        }

        return data
    }
}

// MARK: APIClient.APIClientError

extension APIClient { }

// MARK: - APIClientError

public enum APIClientError: LocalizedError {
    case badServerResponse(Int)
    case serverError(message: String)
    case invalidServerResponse

    public var localizedDescription: String {
        switch self {
        case .badServerResponse(let statusCode):
            "API request failed. Server status code: \(statusCode)"

        case .serverError(let message):
            switch message {
            case "email_already_exists":
                "Could not register with this email. Please try another one"
            case "captcha_incorrect":
                "Captcha is incorrect. Please try again"
            default:
                "Server error: \(message)"
            }

        case .invalidServerResponse:
            "Invalid server response"
        }
    }
}
