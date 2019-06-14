import Foundation

@objc
class HSMediaLibraryDateQuery: NSObject {
  typealias SortEquation = HSMediaLibraryQuerySortEquation

  internal let date: Date
  internal let equation: SortEquation

  init(date: Date, equation: SortEquation) {
    self.date = date
    self.equation = equation
    super.init()
  }

  @objc
  public static func from(dict: NSDictionary) -> HSMediaLibraryDateQuery? {
    guard
      let equationString = dict["equation"] as? String,
      let equation = SortEquation.from(string: equationString),
      let dateString = dict["date"] as? String,
      let date = HSDateFormatter.date(from: dateString)
    else {
      return nil
    }
    return HSMediaLibraryDateQuery(date: date, equation: equation)
  }

  public func predicate(forVariableNamed variableName: String) -> NSPredicate {
    let operatorString = equation.operatorString
    return NSPredicate(format: "\(variableName) \(operatorString) %@", argumentArray: [date])
  }
}
