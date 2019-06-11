import Foundation

@objc
internal class HSMediaLibraryBasicQuery: NSObject {
  internal static let DefaultLimit: Int = 100
  internal let limit: Int
  internal let creationDateQuery: HSMediaLibraryDateQuery?

  internal init(creationDateQuery: HSMediaLibraryDateQuery?, limit: Int = DefaultLimit) {
    self.creationDateQuery = creationDateQuery
    self.limit = limit
    super.init()
  }

  @objc
  internal init?(dict: NSDictionary) {
    guard
      let limit = dict["limit"] as? Int,
      let dateQueryDict = dict["creationDateQuery"] as? NSDictionary?
    else {
      return nil
    }
    let creationDateQuery: HSMediaLibraryDateQuery? = dateQueryDict != nil
      ? HSMediaLibraryDateQuery.from(dict: dateQueryDict!)
      : nil
    self.creationDateQuery = creationDateQuery
    self.limit = limit
    super.init()
  }
}
