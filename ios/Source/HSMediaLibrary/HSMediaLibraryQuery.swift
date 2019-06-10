import Foundation

@objc
class HSMediaLibraryQuery: NSObject {
  internal let mediaType: HSMediaType

  init(mediaType: HSMediaType) {
    self.mediaType = mediaType
    super.init()
  }

  @objc
  public static func from(dict: NSDictionary) -> HSMediaLibraryQuery? {
    guard
      let mediaTypeString = dict["mediaType"] as? String,
      let mediaType = HSMediaType.from(string: mediaTypeString)
    else {
      return nil
    }
    return HSMediaLibraryQuery(mediaType: mediaType)
  }
}
