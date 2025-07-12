import Foundation

public enum ExpirationDeadline {
  case oneHour
  case oneDay
  case oneWeek

  public var timeInterval: TimeInterval {
    switch self {
    case .oneHour:
      60 * 60
    case .oneDay:
      60 * 60 * 24
    case .oneWeek:
      60 * 60 * 24 * 7
    }
  }
}
