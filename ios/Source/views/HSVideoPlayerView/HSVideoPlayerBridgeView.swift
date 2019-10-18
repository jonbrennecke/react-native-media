import Photos
import UIKit

@available(iOS 10.0, *)
@objc
class HSVideoPlayerBridgeView: HSVideoPlayerView {
  @objc
  public var onPlaybackStateDidChange: RCTDirectEventBlock?

  @objc
  public var onVideoDidFailToLoad: RCTDirectEventBlock?

  @objc
  public var onPlaybackTimeDidUpdate: RCTDirectEventBlock?

  @objc
  public var onVideoDidPlayToEnd: RCTDirectEventBlock?

  @objc
  public var onOrientationDidLoad: RCTDirectEventBlock?

  @objc
  public func loadAsset(withAssetID assetID: String?, completionHandler: @escaping (AVAsset?) -> Void) {
    guard let assetID = assetID else {
      completionHandler(nil)
      return
    }
    let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: [assetID], options: nil)
    guard let asset = fetchResult.firstObject else {
      completionHandler(nil)
      return
    }
    let videoRequestOptions = PHVideoRequestOptions()
    videoRequestOptions.deliveryMode = .highQualityFormat
    PHImageManager.default().requestAVAsset(forVideo: asset, options: videoRequestOptions) {
      asset, _, _ in
      completionHandler(asset)
    }
  }
}
