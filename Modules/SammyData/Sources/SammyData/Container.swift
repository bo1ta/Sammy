import Factory

extension Container {
    public var currentUserProvider: Factory<CurrentUserProviderProtocol> {
        self { CurrentUserManager() }
            .cached
    }

    public var userRepository: Factory<UserRepositoryProtocol> {
        self { UserRepository() }
    }

    public var userStore: Factory<UserStore> {
        self { UserStore() }
            .cached
    }

    public var commentRepository: Factory<CommentRepositoryProtocol> {
        self { CommentRepository() }
    }

    public var authenticationHandler: Factory<AuthenticationHandlerProtocol> {
        self { AuthenticationHandler() }
    }
}
