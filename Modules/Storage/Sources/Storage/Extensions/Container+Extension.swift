import Factory

extension Container {
    public var storageManager: Factory<StorageManagerType> {
        self { StorageManager() }
            .onTest { InMemoryStorageManager() }
            .onPreview { InMemoryStorageManager() }
            .singleton
    }

    public var coreDataStore: Factory<CoreDataStore> {
        self { CoreDataStore() }
    }
}
