# Networking

## Overview

The `Networking` module provides a lightweight, type-safe, and extensible framework for making HTTP API requests in the application. It is responsible for:
- Defining a core `APIClient` for dispatching HTTP requests and handling responses.
- Providing service protocols (e.g., `PostServiceProtocol`) and implementations (e.g., `PostService`) for specific API operations.
- Managing API endpoints via a structured `Route` and `APIRoute` enum hierarchy.
- Integrating with the `Models` module for decoding API responses into domain models (e.g., `Post`).

This module is designed to be decoupled from UI and persistence layers, relying only on the `Models` module for domain models

## Components

### APIClient

The `APIClient` struct is the core networking component, conforming to the `APIProvider` protocol. It:

- Dispatches `APIRequest` objects as HTTP requests using `URLSession`.
- Validates server responses, throwing errors for non-2xx status codes.

**Usage**:
```swift
import Networking

let client = APIClient()
let request = APIRequest(method: .get, route: .post(.list))
let data = try await client.dispatch(request)
```

### DecodableModel

The `DecodableModel` protocol provides a convenient way to decode data into `Decodable` entities. 

All you have to do is to conform your decodable entities to `DecodableModel`, then call one of it's static methods (`createFrom` or `createArrayFrom`) to construct the model.

**Usage**:
```swift
struct User: Decodable, DecodableModel {
	var id: Int
}

let data = try await client.dispatch(request)
let user = try User.createFrom(data)
```

### Service Protocols and Implementations

Services encapsulate specific API operations, following a protocol-oriented design. For example:
- `PostServiceProtocol`: Defines methods for fetching posts (e.g. `fetchPosts()`)
- `PostService`: Implements `PostServiceProtocol`, using `APIClient` to dispatch requests and decode responses into `[Post]` from the `Models` module

**Usage**:
```swift
import Networking

let service = PostService()
let posts = try await service.fetchPosts()
```

### Routes and Endpoints

API endpoints are defined using the `Route` and `APIRoute` enums, providing type-safe way to construct URL paths. For example:
`Route.post(.list)` maps to `/post/list`

**Usage**:
```swift
let request = APIRequest(method: .get, route: .post(.list))
```

## Usage

To use the `Networking` module:

1. Import the Module
```swift
import Networking
```

2. Perform API Requests:

- Use `APIClient` directly for low-level requests

```swift
let client = APIClient()
let request = APIRequest(method: .get, route: .post(.list))
let data = try await client.dispatch(request)
let posts = FetchPostsResponse.createFrom(data).posts
```

3. Define New Services:

- Create a new protocol (e.g. `UserServiceProtocol`) and implementation
- Define new routes in `APIRoute` and `Route` if needed
- Use `APIClient` to dispatch requests. For decoding responses, conform your `Decodable` model to the `DecodableModel` protocol and use one of its static methods

**Example**:
```swift
public protocol UserServiceProtocol {
    func fetchUsers() async throws -> [User]
}

public struct UserService: UserServiceProtocol {
    private let client: APIProvider
    
    public init(client: APIProvider = APIClient()) {
        self.client = client
    }
    
    public func fetchUsers() async throws -> [User] {
        let request = APIRequest(method: .get, route: .user(.list))
        let data = try await client.dispatch(request)
        return try User.createArrayFrom(data)
    }
}
```

### Conventions

When contributing to or extending this module, follow these guidelines:
- Protocol-Oriented Design: Define service protocols for each API domain (e.g. posts, users) to ensure testability and flexibility.
- Type-Safe Routes: Add new routes to `Route` and `APIRoute` enums to maintain type safety

### Adding a New Service

To add a new service:

1. Create a new Swift file (e.g. `UserService.swift`)
2. Define a protocol (e.g. `UserServiceProtocol`) with the required methods
3. Implement the protocol in a struct (e.g. `UserService`), using `APIClient` for requests
4. Add any necessary routes to `Route` and `APIRoute`.
6. Define a `Decodable` response if needed, or add one to the `Models` if it's a public one.
7. Write unit tests to verify the service behavior.

## Testing
The module includes unit tests to verify:
- `APIClient` request dispatching and error handling
- Service implementations (e.g. `PostService`) for correct request construction and response decoding
- Route path generation

Tests are located in the `NetworkingTests` target. Run them using:

`xcodebuild test -scheme Networking -destination 'platform=iOS Simulator,name=iPhone 15'`

To test services, use a mock `APIProvider` to simulate network responses. Example: 

```swift
struct MockAPIProvider: APIProvider {
	var expectedData: Data?

	func dispatch(_ request: APIRequest) async throws -> Data {
		if let expectedData {
			return expectedData
		}
		throw Error
	}

}
```

You can make your test class conform to `SammyTestBase`, and pass a json file as data by using the convenient `parseDataFromFile(from: _)`. Say you added a `postsListResponse.json` file to `Networking/Tests/NetworkingTests/Supporting Files`:

```swift
@Suite
class PostServiceTests: SammyTestBase {
    @Test func fetchPostsSuccess() async throws {
        let jsonData = try parseDataFromFile(name: "postsListResponse")
        let mockAPI = MockAPIProvider(expectedData: jsonData)

        let service = PostService(client: mockAPI)
        let posts = try await service.fetchPosts()
        #expect(posts.count == 2)
    }
}
```

### Contributing

To contribute:

1. Fork the repository and create a feature branch
2. Follow the conventions outlined above
3. Submit a pull request with a clear description of changes
4. Ensure all tests pass and add new tests for new services or routes

