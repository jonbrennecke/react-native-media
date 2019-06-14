import Foundation

@objc
class HSMediaLibraryTitleQuery: NSObject {
  typealias SortEquation = HSMediaLibraryQuerySortEquation

  internal let title: String
  internal let equation: SortEquation

  init(title: String, equation: SortEquation) {
    self.title = title
    self.equation = equation
    super.init()
  }

  @objc
  public static func from(dict: NSDictionary) -> HSMediaLibraryTitleQuery? {
    guard
      let equationString = dict["equation"] as? String,
      let equation = SortEquation.from(string: equationString),
      let title = dict["title"] as? String
    else {
      return nil
    }
    return HSMediaLibraryTitleQuery(title: title, equation: equation)
  }

  public func predicate(forVariableNamed variableName: String) -> NSPredicate {
    let operatorString = equation.operatorString
    return NSPredicate(format: "\(variableName) \(operatorString) %@", argumentArray: [title])
  }
}
