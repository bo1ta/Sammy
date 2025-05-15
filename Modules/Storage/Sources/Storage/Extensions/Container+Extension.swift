import Factory

extension Container {
    var storageManager: Factory<StorageManagerType> {
        self { StorageManager() }
            .onTest { InMemoryStorageManager() }
            .onPreview { InMemoryStorageManager() }
            .singleton
    }
}
