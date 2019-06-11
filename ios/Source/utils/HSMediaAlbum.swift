import Foundation
import Photos

@objc
internal class HSMediaAlbum: NSObject {
  internal let albumID: String
  internal let count: Int
  internal let title: String

  @objc
  convenience init(collection: PHAssetCollection) {
    self.init(
      albumID: collection.localIdentifier,
      count: collection.estimatedAssetCount,
      title: collection.localizedTitle ?? ""
    )
  }

  init(albumID: String, count: Int, title: String) {
    self.albumID = albumID
    self.count = count
    self.title = title
    super.init()
  }
}

extension HSMediaAlbum: NSDictionaryConvertible {
  @objc
  public func asDictionary() -> NSDictionary {
    return [
      "albumID": albumID,
      "count": count,
      "title": title,
    ] as NSDictionary
  }
}
