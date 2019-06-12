import Foundation

@objc
internal final class HSMediaLibraryMediaQuery: HSMediaLibraryBasicQuery {
  internal let mediaType: HSMediaType
  internal let albumID: String?

  init(mediaType: HSMediaType, albumID: String?, creationDateQuery: HSMediaLibraryDateQuery?, limit: Int = DefaultLimit) {
    self.mediaType = mediaType
    self.albumID = albumID
    super.init(creationDateQuery: creationDateQuery, limit: limit)
  }

  private init?(mediaType: HSMediaType, albumID: String?, dict: NSDictionary) {
    self.mediaType = mediaType
    self.albumID = albumID
    super.init(dict: dict)
  }

  @objc
  public convenience override init?(dict: NSDictionary) {
    guard
      let mediaTypeString = dict["mediaType"] as? String,
      let albumID = dict["albumID"] as? String?
    else {
      return nil
    }
    let mediaType = HSMediaType.from(string: mediaTypeString)
    self.init(mediaType: mediaType, albumID: albumID, dict: dict)
  }
}
