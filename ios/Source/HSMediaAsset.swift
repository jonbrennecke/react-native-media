import Foundation
import Photos

fileprivate let DEFAULT_LIMIT = 100

@objc
class HSMediaAsset: NSObject {
  internal let creationDate: Date?
  internal let assetID: String
  internal let duration: TimeInterval

  @objc
  convenience init(asset: PHAsset) {
    self.init(assetID: asset.localIdentifier, duration: asset.duration, creationDate: asset.creationDate)
  }

  init(assetID: String, duration: CFTimeInterval, creationDate: Date?) {
    self.assetID = assetID
    self.duration = duration
    self.creationDate = creationDate
    super.init()
  }

  @objc
  public func asDict() -> NSDictionary {
    return [
      "assetID": assetID,
      "duration": duration,
      "creationDate": (creationDate != nil
        ? HSDateFormatter.string(from: creationDate!) ?? NSNull() as Any
        : NSNull() as Any),
    ] as NSDictionary
  }
}
