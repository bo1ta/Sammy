import Factory

extension Container {
    var client: Factory<APIClientProvider> {
        self { APIClient() }
    }

    public var authService: Factory<AuthServiceProtocol> {
        self { AuthService() }
    }

    public var commentService: Factory<CommentServiceProtocol> {
        self { CommentService() }
    }

    public var communityService: Factory<CommunityServiceProtocol> {
        self { CommunityService() }
    }

    public var postService: Factory<PostServiceProtocol> {
        self { PostService() }
    }

    public var userService: Factory<UserServiceProtocol> {
        self { UserService() }
    }

    public var tokenProvider: Factory<TokenProviderType> {
        self { TokenProvider() }
            .cached
    }
}
