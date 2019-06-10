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

internal func imageOrientation(forSize size: CGSize) -> UIImage.Orientation {
  if size.width > size.height {
    return .right
  } else {
    return .up
  }
}
