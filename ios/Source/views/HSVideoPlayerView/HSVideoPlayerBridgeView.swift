import UIKit

@available(iOS 10.0, *)
@objc
class HSVideoPlayerBridgeView: HSVideoPlayerView {
  @objc
  public var onPlaybackStateChange: RCTDirectEventBlock?

  @objc
  public var onVideoDidFailToLoad: RCTDirectEventBlock?

  @objc
  public var onVideoDidUpdatePlaybackTime: RCTDirectEventBlock?

  @objc
  public var onVideoWillRestart: RCTDirectEventBlock?
}
