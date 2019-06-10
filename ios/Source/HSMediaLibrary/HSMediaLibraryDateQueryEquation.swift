enum HSMediaLibraryDateQueryEquation {
  case greaterThan
  case greaterThanOrEqualTo
  case equalTo
  case lessThan
  case lessThanOrEqualTo

  public static func from(string: String) -> HSMediaLibraryDateQueryEquation? {
    switch string {
    case "greaterThan":
      return .greaterThan
    case "greaterThanOrEqualTo":
      return .greaterThanOrEqualTo
    case "equalTo":
      return .equalTo
    case "lessThan":
      return .lessThan
    case "lessThanOrEqualTo":
      return .lessThanOrEqualTo
    default:
      return nil
    }
  }

  public var operatorString: String {
    switch self {
    case .greaterThan:
      return ">"
    case .greaterThanOrEqualTo:
      return ">="
    case .equalTo:
      return "=="
    case .lessThan:
      return "<"
    case .lessThanOrEqualTo:
      return "<="
    }
  }
}
