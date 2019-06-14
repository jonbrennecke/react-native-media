import Foundation

@objc
internal final class HSMediaLibraryMediaQuery: HSMediaLibraryBasicQuery {
  internal let mediaType: HSMediaType
  internal let albumID: String?
  internal let creationDateQuery: HSMediaLibraryDateQuery?

  init(mediaType: HSMediaType, albumID: String?, creationDateQuery: HSMediaLibraryDateQuery?, limit: Int = DefaultLimit) {
    self.mediaType = mediaType
    self.albumID = albumID
    self.creationDateQuery = creationDateQuery
    super.init(limit: limit)
  }

  private init?(mediaType: HSMediaType, albumID: String?, creationDateQuery: HSMediaLibraryDateQuery?, dict: NSDictionary) {
    self.mediaType = mediaType
    self.albumID = albumID
    self.creationDateQuery = creationDateQuery
    super.init(dict: dict)
  }

  @objc
  public convenience override init?(dict: NSDictionary) {
    guard
      let mediaTypeString = dict["mediaType"] as? String,
      let albumID = dict["albumID"] as? String?,
      let dateQueryDict = dict["creationDateQuery"] as? NSDictionary?
    else {
      return nil
    }
    let creationDateQuery: HSMediaLibraryDateQuery? = dateQueryDict != nil
      ? HSMediaLibraryDateQuery.from(dict: dateQueryDict!)
      : nil
    let mediaType = HSMediaType.from(string: mediaTypeString)
    self.init(mediaType: mediaType, albumID: albumID, creationDateQuery: creationDateQuery, dict: dict)
  }
}
