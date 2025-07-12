protocol NavigationPathProtocol {
  associatedtype Destination: NavigationDestination

  var elements: [Destination] { get }

  mutating func append(_ element: Destination)
  mutating func removeLast()
}
