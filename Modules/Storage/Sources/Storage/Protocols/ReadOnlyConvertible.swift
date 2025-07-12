/// Enables conversion between NSManagedObject instances and read-only Swift value types
/// Typically used to provide immutable models to the UI layer
///
public protocol ReadOnlyConvertible {
  /// The associated read-only model type
  associatedtype ReadOnlyType: Sendable

  /// Converts the managed object to its read-only representation
  func toReadOnly() -> ReadOnlyType
}
