import Foundation

@objc
internal class HSMediaLibraryBasicQuery: NSObject {
  internal static let DefaultLimit: Int = 100
  internal let limit: Int

  internal init(limit: Int = DefaultLimit) {
    self.limit = limit
    super.init()
  }

  @objc
  internal init?(dict: NSDictionary) {
    guard let limit = dict["limit"] as? Int else {
      return nil
    }
    self.limit = limit
    super.init()
  }
}
