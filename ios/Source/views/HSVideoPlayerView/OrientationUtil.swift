import AVFoundation
import UIKit

@objc
internal class OrientationUtil: NSObject {
  @objc
  internal static func orientation(forAsset asset: AVAsset) -> UIImage.Orientation {
    return HSReactNativeMedia.orientation(forAsset: asset)
  }
}
