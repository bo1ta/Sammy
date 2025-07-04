import Factory

extension Container {
    public var currentUserProvider: Factory<CurrentUserProviderProtocol> {
        self { CurrentUserProvider() }
            .cached
    }

    public var userRepository: Factory<UserRepositoryProtocol> {
        self { UserRepository() }
    }

    public var userStore: Factory<UserStore> {
        self { UserStore() }
            .cached
    }

    public var commentProvider: Factory<CommentDataProviderProtocol> {
        self { CommentDataProvider() }
    }

    public var authenticationHandler: Factory<AuthenticationHandlerProtocol> {
        self { AuthenticationHandler() }
    }
}
