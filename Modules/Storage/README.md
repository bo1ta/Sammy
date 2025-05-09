# Storage

A type-safe, Swift-friendly wrapper around Core Data with Vapor-inspired ergonomics. Provides clean separation between managed objects and read-only models while maintaining full Core Data capabilities.

## Features

- **Type-safe query building** with KeyPath support
- **Automatic model conversion** between Core Data entities and Swift value types
- **Thread-safe** operations
- **Vapor-like fluent interface** for queries
- **Protocol-oriented design** for easy extensibility
- **Built-in logging** for error tracking

# Core Concepts

## 1. Managed Objects <-> Value Types

**Usage**:
```swift
class ManagedPost: NSManagedObject, ReadOnlyConvertible {
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

## 2. Query Building

**Usage**:
```swift
// Basic query. Use keypaths for common operations
let posts = Post.query(on: context)
    .filter(\.title == "Hello")
    .sort(\.date, ascending: false)
    .limit(10)
    .all()

// Complex query -- rarely, if ever, needed
let recentPosts = Post.query(on: context)
    .filter(NSPredicate(format: "createdAt > %@", lastWeek as NSDate))
    .sort(\.viewCount)
    .all()
```

# Usage Guide

## Defining Models

1. Add a new entity in the the SammyDataModel
2. Select the new entity, and in the Data Model inspector, set Class Codegen to Manual/None
3. From the Xcode menu, select Editor > Create NSManangedObject Subclass. Go through the wizard and select your new entity. Save it to Storage/Entities/
4. Xcode might also add these references to the project. We don't need those, so it's save to remove the references (they should appear in the Xcode Navigator, at the top)
5. Make it conform to `ReadOnlyConvertible` and return the associated value type

## Performing Queries

Use the `storageManager.performRead` and `storageManager.performWrite` to get the right context for the job. Reading operations are performed on the view context (main thread) while the write operations are performed on a shared, derived background context.

**Reading**:
```swift
let users = await storageManager.performRead { context in 
	User.query(on: context)
	.all()
	.toReadOnly()
}
```

**Writing**:
```swift
	try await storageManager.performWrite(.immediate) { context in 
		let userEntity = userModel.toEntity(context: context)
	}
```

**Fetching**:
```swift
// Get all
let users = User.query(on: context).all()

// Get first
let admin = User.query(on: context)
    .first(where: \.role == "admin")

// Count
let activeUsers = User.query(on: context)
    .filter(\.isActive == true)
    .count()
```

**Filtering**:
```swift
// KeyPath filter
let filtered = Post.query(on: context)
    .filter(\.category == "tech")
    .all()

// NSPredicate filter
let predicate = NSPredicate(format: "views > %d", 1000)
let popular = Post.query(on: context)
    .filter(predicate)
    .all()
```

**Sorting**
```swift
// Single sort
let sorted = User.query(on: context)
    .sort(\.name)
    .all()

// Multiple sorts
let ordered = Post.query(on: context)
    .sort(\.isPinned, ascending: false)
    .sort(\.createdAt, ascending: false)
    .all()
```

**Inserting/Updating**
```swift
// Convert model to entity
let newPost = Post(title: "Hello", content: "World")
let entity = try newPost.toEntity(in: context)

// Save context
try context.saveIfNeeded()
```

## Best Practices

- **Keep models immutable**  - Use read-only structs for UI consumption
- **Limit fetched properties** - Only request what you need
- **Perform operations on the right context** - use **storageManager.performRead** or **storageManager.performWrite**