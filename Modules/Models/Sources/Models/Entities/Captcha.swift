import Foundation

public struct Captcha: Decodable {
    public let png: String
    public let wav: String
    public let uuid: String

    public enum CodingKeys: CodingKey {
        case png
        case wav
        case uuid
    }

    public init(png: String, wav: String, uuid: String) {
        self.png = png
        self.wav = wav
        self.uuid = uuid
    }
}
