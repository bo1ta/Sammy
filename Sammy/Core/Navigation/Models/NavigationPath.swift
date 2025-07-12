struct NavigationPath<T: NavigationDestination>: NavigationPathProtocol {
  var elements: [T]

  init(_ elements: [T] = []) {
    self.elements = elements
  }

  mutating func append(_ element: T) {
    elements.append(element)
  }

  mutating func removeLast() {
    elements.removeLast()
  }
}
