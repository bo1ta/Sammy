import Foundation
import OSLog

// MARK: - DecodableModel

/// Namespace to group decodable objects
///
public protocol DecodableModel: Decodable { }

// MARK: - Decoding methods

extension DecodableModel {
    public static func createFrom(_ data: Data) throws -> Self {
        do {
            let string = String(data: data, encoding: .utf8) ?? "invalid_response"
            NSLog(string)
            return try JSONHelper.decoder.decode(Self.self, from: data)
        } catch let error as DecodingError {
            NSLog(error.prettyDescription)
            throw error
        }
    }

    public static func createArrayFrom(_ data: Data) throws -> [Self] {
        do {
            let string = String(data: data, encoding: .utf8) ?? "invalid_response"
            NSLog(string)
            return try JSONHelper.decoder.decode([Self].self, from: data)
        } catch let error as DecodingError {
            NSLog(error.prettyDescription)
            throw error
        }
    }
}

// MARK: - JSONHelper

private class JSONHelper {
    static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()

    static let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }()
}

// MARK: - DecodingError + pretty description

extension DecodingError {
    fileprivate var prettyDescription: String {
        switch self {
        case .typeMismatch(let type, let context):
            "DecodingError.typeMismatch \(type), value \(context.prettyDescription) @ ERROR: \(localizedDescription)"
        case .valueNotFound(let type, let context):
            "DecodingError.valueNotFound \(type), value \(context.prettyDescription) @ ERROR: \(localizedDescription)"
        case .keyNotFound(let key, let context):
            "DecodingError.keyNotFound \(key), value \(context.prettyDescription) @ ERROR: \(localizedDescription)"
        case .dataCorrupted(let context):
            "DecodingError.dataCorrupted \(context.prettyDescription), @ ERROR: \(localizedDescription)"
        default:
            "DecodingError: \(localizedDescription)"
        }
    }
}

extension DecodingError.Context {
    fileprivate var prettyDescription: String {
        var result = ""
        if !codingPath.isEmpty {
            result.append(codingPath.map(\.stringValue).joined(separator: "."))
            result.append(": ")
        }
        result.append(debugDescription)
        if
            let nsError = underlyingError as? NSError,
            let description = nsError.userInfo["NSDebugDescription"] as? String
        {
            result.append(description)
        }
        return result
    }
}
