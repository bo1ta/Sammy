import Foundation

// MARK: - SammyTestBase

protocol SammyTestBase: AnyObject { }

extension SammyTestBase {
    func parseDataFromFile(name: String, withExtension fileExtension: String = "json") throws -> Data {
        guard
            let fileURL = Bundle(for: Self.self)
                .url(forResource: name, withExtension: fileExtension)
        else {
            throw NSError(domain: "SammyTests", code: 1, userInfo: nil)
        }
        return try Data(contentsOf: fileURL)
    }
}
