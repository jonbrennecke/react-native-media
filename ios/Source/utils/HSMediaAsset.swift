import Foundation
import Photos

@objc
class HSMediaAsset: NSObject {
  internal let creationDate: Date?
  internal let assetID: String
  internal let duration: TimeInterval
  internal let mediaType: HSMediaType

  @objc
  convenience init(asset: PHAsset) {
    self.init(
      assetID: asset.localIdentifier,
      duration: asset.duration,
      creationDate: asset.creationDate,
      mediaType: HSMediaType.from(assetMediaType: asset.mediaType)
    )
  }

  init(assetID: String, duration: CFTimeInterval, creationDate: Date?, mediaType: HSMediaType) {
    self.assetID = assetID
    self.duration = duration
    self.creationDate = creationDate
    self.mediaType = mediaType
    super.init()
  }
}

extension HSMediaAsset : NSDictionaryConvertible {
  @objc
  public func asDictionary() -> NSDictionary {
    return [
      "assetID": assetID,
      "duration": duration,
      "creationDate": (creationDate != nil
        ? HSDateFormatter.string(from: creationDate!) ?? NSNull() as Any
        : NSNull() as Any),
      "mediaType": mediaType.stringValue,
    ] as NSDictionary
  }
}
