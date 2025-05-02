import Foundation

public struct CreatorData: Codable, Identifiable, Sendable {
    public var id: Int
    public var name: String
    public var banned: Bool
    public var actorID: String
    public var instanceID: Int
    public var isLocal: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case banned
        case actorID = "actor_id"
        case instanceID = "instance_id"
        case isLocal = "local"
    }

    public init(id: Int, name: String, banned: Bool, actorID: String, instanceID: Int, isLocal: Bool) {
        self.id = id
        self.name = name
        self.banned = banned
        self.actorID = actorID
        self.instanceID = instanceID
        self.isLocal = isLocal
    }
}
