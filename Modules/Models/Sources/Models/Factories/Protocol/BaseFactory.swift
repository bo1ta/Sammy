// MARK: - BaseFactory

/// Protocol to group helper methods
///
public protocol BaseFactory { }

extension BaseFactory {

    /// Returns a random `Int` between `1` and `Int.max`
    ///
    public static func randomInt() -> Int {
        Int.random(in: 1...Int.max)
    }
}
