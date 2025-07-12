import Foundation

public struct PersonProfile: Decodable, Sendable {
  public let person: PersonAttributes
  public let personCounts: PersonCounts
  public let isAdmin: Bool

  enum CodingKeys: String, CodingKey {
    case person
    case personCounts = "counts"
    case isAdmin = "is_admin"
  }

  public init(person: PersonAttributes, personCounts: PersonCounts, isAdmin: Bool) {
    self.person = person
    self.personCounts = personCounts
    self.isAdmin = isAdmin
  }
}
