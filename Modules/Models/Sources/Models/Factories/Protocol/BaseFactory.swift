// MARK: - BaseFactory

/// Protocol to group helper methods
///
protocol BaseFactory { }

extension BaseFactory {

    /// Returns a random `Int` between `1` and `Int.max`
    ///
    static func randomInt() -> Int {
        Int.random(in: 1...Int.max)
    }
}
