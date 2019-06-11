import Foundation

@objc
internal final class HSMediaLibraryMediaQuery: HSMediaLibraryBasicQuery {
  internal let mediaType: HSMediaType

  init(mediaType: HSMediaType, creationDateQuery: HSMediaLibraryDateQuery?, limit: Int = DefaultLimit) {
    self.mediaType = mediaType
    super.init(creationDateQuery: creationDateQuery, limit: limit)
  }

  private init?(mediaType: HSMediaType, dict: NSDictionary) {
    self.mediaType = mediaType
    super.init(dict: dict)
  }

  @objc
  public convenience override init?(dict: NSDictionary) {
    guard let mediaTypeString = dict["mediaType"] as? String else {
      return nil
    }
    let mediaType = HSMediaType.from(string: mediaTypeString)
    self.init(mediaType: mediaType, dict: dict)
  }
}
