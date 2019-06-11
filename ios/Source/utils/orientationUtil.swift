import AVFoundation
import UIKit

internal func isPortrait(orientation: UIImage.Orientation) -> Bool {
  return !isLandscape(orientation: orientation)
}

internal func isLandscape(orientation: UIImage.Orientation) -> Bool {
  switch orientation {
  case .left, .leftMirrored, .right, .rightMirrored:
    return true
  default:
    return false
  }
}

internal func orientation(forSize size: CGSize) -> UIImage.Orientation {
  if size.width > size.height {
    return .right
  } else {
    return .up
  }
}

internal func orientation(forAsset asset: AVAsset) -> UIImage.Orientation {
  let videoTracks = asset.tracks(withMediaType: .video)
  guard let videoTrack = videoTracks.first else {
    return .right
  }
  let size = videoTrack.naturalSize.applying(videoTrack.preferredTransform)
  let positiveSize = CGSize(width: abs(size.width), height: abs(size.height))
  return orientation(forSize: positiveSize)
}
