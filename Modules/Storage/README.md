# Storage

A type-safe, Swift-friendly wrapper around Core Data. Provides clean separation between managed objects and read-only models while maintaining full Core Data capabilities.

## Features

- **Type-safe query building** with KeyPath support
- **Automatic model conversion** between Core Data entities and Swift value types
- **Thread-safe** operations
- **Protocol-oriented design** for easy extensibility

# Core Concepts

## 1. Entity <-> Value Type

### Convert entities to value types for thread safety by conforming to `ReadOnlyConvertible`

**Usage**:
```swift
class PostEntity: NSManagedObject, ReadOnlyConvertible {
    @NSManaged var id: UUID
    @NSManaged var title: String
    @NSManaged var content: String
    
    func toReadOnly() -> Post {
        Post(id: id, title: title, content: content)
    }
}

// Immutable Model
struct Post {
	let id: UUID
	let title: String
	let content: String
}
```

## 2. Core data operations

### Perform the read operations using the `ReadOnlyStore`. Most of its methods return the associated `ReadOnlyType` for the given entities

```swift
let readOnlyPost = CoreDataStore.readOnlyStore().firstObject(of: PostEntity.self, using: \.id == id)
```

Or, for more control:

```swift
CoreDataStore.readOnlyStore().performRead { storage in 
    // Use `storage` to perform various operations
}
```

### Perform the write operations using the `WriteOnlyStore`

```swift
CoreDataStore.writeOnlyStore().synchronize(post, ofType: PostEntity.self)
```

Or, for more control:

```swift
CoreDataStore.readOnlyStore().performWrite(.now) { storage in 
    // Use `storage` to perform various operations
}
```


# Usage Guide

## Defining Models

1. Add a new entity in the the SammyDataModel
2. Select the new entity, and in the Data Model inspector, set Class Codegen to Manual/None
3. From the Xcode menu, select Editor > Create NSManangedObject Subclass. Go through the wizard and select your new entity. Save it to Storage/Entities/
4. Xcode might also add these references to the project. We don't need those, so it's save to remove the references (they should appear in the Xcode Navigator, at the top)
5. Make it conform to `ReadOnlyConvertible` and return the associated value type

## Best Practices

- **Keep models immutable**  - Use read-only structs for UI consumption
- **Limit fetched properties** - Only request what you need
- **Perform operations on the right context**
