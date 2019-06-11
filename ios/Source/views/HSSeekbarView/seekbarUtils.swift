import CoreMedia
import UIKit

fileprivate let SEEKBAR_IMAGE_RATIO: CGFloat = 9 / 16
fileprivate let SIZE_ZERO = CGSize(
  width: CGFloat.leastNonzeroMagnitude,
  height: CGFloat.leastNonzeroMagnitude
)

internal func createSeekbarTimeValues(numberOfImages: Int, duration: TimeInterval) -> [NSValue] {
  let step = duration / Double(numberOfImages)
  var times = [NSValue]()
  for seconds in stride(from: 0, to: duration, by: step) {
    let time = CMTimeMakeWithSeconds(seconds, preferredTimescale: 600)
    times.append(time as NSValue)
  }
  return times
}

internal func createSeekbarConfig(size: CGSize) -> (size: CGSize, numberOfImages: Int) {
  if size.width < SIZE_ZERO.width, size.height < SIZE_ZERO.height {
    return (size: .zero, numberOfImages: 0)
  }
  let imageHeight = size.height
  let imageWidth = imageHeight * SEEKBAR_IMAGE_RATIO
  let imageSize = CGSize(width: imageWidth, height: imageHeight)
  let numberOfImages = Int((size.width / imageWidth).rounded(.up))
  return (size: imageSize, numberOfImages: numberOfImages)
}
