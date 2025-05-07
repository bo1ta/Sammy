protocol ReadOnlyConvertible {
    associatedtype ReadOnlyType

    func toReadOnly() -> ReadOnlyType
}
