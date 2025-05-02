import Foundation

// MARK: - APIClient

public struct APIClient: APIProvider {
    private let session: URLSession

    public init(session: URLSession = .shared) {
        self.session = session
    }

    public func dispatch(_ request: APIRequest) async throws -> Data {
        let urlRequest = try request.asURLRequest()
        let (data, response) = try await session.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
            throw APIClientError.badServerResponse(statusCode)
        }

        return data
    }
}

// MARK: APIClient.APIClientError

extension APIClient {
    private enum APIClientError: LocalizedError {
        case badServerResponse(Int)

        var localizedDescription: String {
            switch self {
            case .badServerResponse(let statusCode):
                "API request failed. Server status code: \(statusCode)"
            }
        }
    }
}
