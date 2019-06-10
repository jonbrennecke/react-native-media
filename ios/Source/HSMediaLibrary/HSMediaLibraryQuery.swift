import Foundation

fileprivate let DEFAULT_LIMIT = 100

@objc
class HSMediaLibraryQuery: NSObject {
  internal let mediaType: HSMediaType
  internal let limit: Int

  init(mediaType: HSMediaType, limit: Int = DEFAULT_LIMIT) {
    self.mediaType = mediaType
    self.limit = limit
    super.init()
  }

  @objc
  public static func from(dict: NSDictionary) -> HSMediaLibraryQuery? {
    guard
      let mediaTypeString = dict["mediaType"] as? String,
      let mediaType = HSMediaType.from(string: mediaTypeString),
      let limit = dict["limit"] as? Int
    else {
      return nil
    }
    return HSMediaLibraryQuery(mediaType: mediaType, limit: limit)
  }
}
