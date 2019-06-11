import Foundation

fileprivate let DEFAULT_LIMIT = 100

@objc
class HSMediaLibraryQuery: NSObject {
  internal let mediaType: HSMediaType
  internal let limit: Int
  internal let creationDateQuery: HSMediaLibraryDateQuery?

  init(mediaType: HSMediaType, creationDateQuery: HSMediaLibraryDateQuery?, limit: Int = DEFAULT_LIMIT) {
    self.mediaType = mediaType
    self.creationDateQuery = creationDateQuery
    self.limit = limit
    super.init()
  }

  @objc
  public static func from(dict: NSDictionary) -> HSMediaLibraryQuery? {
    guard
      let mediaTypeString = dict["mediaType"] as? String,
      let limit = dict["limit"] as? Int,
      let dateQueryDict = dict["creationDateQuery"] as? NSDictionary?
    else {
      return nil
    }
    let mediaType = HSMediaType.from(string: mediaTypeString)
    let creationDateQuery: HSMediaLibraryDateQuery? = dateQueryDict != nil
      ? HSMediaLibraryDateQuery.from(dict: dateQueryDict!)
      : nil
    return HSMediaLibraryQuery(mediaType: mediaType, creationDateQuery: creationDateQuery, limit: limit)
  }
}
