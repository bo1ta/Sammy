import Factory

extension Container {
    var toastManager: Factory<ToastManagerProtocol> {
        self { ToastManager() }
            .cached
    }

    var navigationCoordinator: Factory<NavigationCoordinator> {
        self { NavigationCoordinator() }
            .singleton
    }
}
