import CoreData
import Foundation
import OSLog

// MARK: - CoreDataPopulator

enum CoreDataPopulator {
  private static let logger = Logger(subsystem: "com.Sammy.Storage", category: "CoreDataPopulator")

  /// Populate entity by mirroring model's properties.
  /// `Note`: This does not populate relationships.
  ///
  @discardableResult
  static func populateFromModel<Entity: NSManagedObject>(
    _ model: some Decodable,
    toEntity entity: Entity,
    nameMapping: [String: String])
    -> Entity
  {
    let mirrorModel = Mirror(reflecting: model)

    for case (let label?, let modelValue) in mirrorModel.children {
      let entityPropertyName = nameMapping[label] ?? label

      guard let attributeType = entity.entity.attributesByName[entityPropertyName]?.attributeType else {
        logger.warning("Property \(entityPropertyName) not found on entity")
        continue
      }

      if let convertedValue = convertValue(modelValue, toType: attributeType) {
        entity.setValue(convertedValue, forKey: entityPropertyName)
      } else if entity.entity.propertiesByName[entityPropertyName]?.isOptional ?? false {
        entity.setValue(nil, forKey: entityPropertyName)
      } else {
        logger.error("Cannot set non-optional property \(entityPropertyName) on entity")
      }
    }

    return entity
  }

  /// Helper to handle type conversions (Int -> NSNumber, etc.)
  /// e.g., if value is Int and targetType is .integer64Attribute or .integer32Attribute, return `NSNumber(integerValue: value)`
  ///
  /// Return nil if conversion isn't straightforward or value is nil
  ///
  private static func convertValue(_ value: Any, toType targetType: NSAttributeType) -> Any? {
    switch value {
    case let intValue as Int:
      return intValue

    case let doubleValue as Double:
      if targetType == .doubleAttributeType || targetType == .floatAttributeType {
        return doubleValue as NSNumber
      }

    case let boolValue as Bool:
      if targetType == .booleanAttributeType {
        return boolValue
      }

    case let dateValue as Date:
      if targetType == .dateAttributeType {
        return dateValue
      }

    case let uuidValue as UUID:
      if targetType == .UUIDAttributeType {
        return uuidValue
      }

    case let stringValue as String:
      if targetType == .stringAttributeType {
        return stringValue
      }

    case let stringRepresentable as any RawRepresentable:
      if let stringRawValue = stringRepresentable.rawValue as? String, targetType == .stringAttributeType {
        return stringRawValue
      } else if
        let intRawValue = stringRepresentable.rawValue as? Int,
        targetType == .integer64AttributeType || targetType == .integer32AttributeType || targetType ==
        .integer16AttributeType
      {
        return intRawValue as NSNumber
      }

    default:
      break
    }

    return nil
  }

}

// MARK: CoreDataPopulator.CoreDataPopulatorError

extension CoreDataPopulator {
  enum CoreDataPopulatorError: LocalizedError {
    case unableToConvertValue

    var errorDescription: String? {
      switch self {
      case .unableToConvertValue:
        "Unable to convert value to CoreData compatible type"
      }
    }
  }
}
