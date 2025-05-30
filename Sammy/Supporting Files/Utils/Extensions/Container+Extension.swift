import Factory

extension Container {
    var toastManager: Factory<ToastManagerProtocol> {
        self { ToastManager() }
            .cached
    }

    var loadingManager: Factory<LoadingManager> {
        self { LoadingManager() }
            .cached
    }
}
