import Foundation
import Testing
@testable import Networking

@Suite
struct APIRequestTests {
    @Test
    func asURLRequestWithoutQueryParamsOrBady() async throws {
        let mockRoute = Route.post(.list)
        let expectedURL = APIEndpoint.baseWithRoute(mockRoute)

        let request = APIRequest(method: .get, route: mockRoute)
        let urlRequest = try request.asURLRequest()
        #expect(urlRequest.url == expectedURL)
        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.allHTTPHeaderFields?[Constants.HTTPHeaderKey.contentType] == "application/json")
        #expect(urlRequest.allHTTPHeaderFields?[Constants.HTTPHeaderKey.authorization] == nil)
        #expect(urlRequest.httpBody == nil)
    }

    @Test
    func asURLRequestWithParamsAndBody() async throws {
        let mockRoute = Route.post(.list)
        let expectedURL = APIEndpoint.baseWithRoute(mockRoute)
        let body: JSONDictionary = ["key": "value"]
        let queryParams = [URLQueryItem(name: "param", value: "value")]
        let authToken = "some-token"

        let request = APIRequest(method: .post, route: mockRoute, queryParams: queryParams, body: body, authToken: authToken)
        let urlRequest = try request.asURLRequest()
        #expect(urlRequest.url == expectedURL)
        #expect(urlRequest.httpMethod == "POST")
        #expect(urlRequest.allHTTPHeaderFields?[Constants.HTTPHeaderKey.contentType] == "application/json")
        #expect(urlRequest.allHTTPHeaderFields?[Constants.HTTPHeaderKey.authorization] == authToken)
        #expect(urlRequest.httpBody != nil)
    }
}
