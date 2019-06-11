import Foundation
import Photos

@objc
internal class HSMediaAlbum: NSObject {
  internal let albumID: String
  internal let startDate: Date?
  internal let endDate: Date?
  internal let count: Int
  internal let title: String

  @objc
  convenience init(collection: PHAssetCollection) {
    self.init(
      albumID: collection.localIdentifier,
      startDate: collection.startDate,
      endDate: collection.endDate,
      count: collection.estimatedAssetCount,
      title: collection.localizedTitle ?? ""
    )
  }

  init(albumID: String, startDate: Date?, endDate: Date?, count: Int, title: String) {
    self.albumID = albumID
    self.startDate = startDate
    self.endDate = endDate
    self.count = count
    self.title = title
    super.init()
  }
}

extension HSMediaAlbum : NSDictionaryConvertible {
  @objc
  public func asDictionary() -> NSDictionary {
    return [
      "albumID": albumID,
      "startDate": (startDate != nil
        ? HSDateFormatter.string(from: startDate!) ?? NSNull() as Any
        : NSNull() as Any),
      "endDate": (endDate != nil
        ? HSDateFormatter.string(from: endDate!) ?? NSNull() as Any
        : NSNull() as Any),
      "count": count,
      "title": title,
    ] as NSDictionary
  }
}
