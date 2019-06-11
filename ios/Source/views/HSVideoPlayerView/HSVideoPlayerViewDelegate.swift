import AVFoundation

@objc
protocol HSVideoPlayerViewDelegate {
  func videoPlayerDidBecomeReadyToPlayAsset(_ asset: AVAsset)
  func videoPlayerDidFailToLoad()
  func videoPlayerDidPause()
  func videoPlayerDidUpdatePlaybackTime(_ time: CMTime, duration: CMTime)
  func videoPlayerDidRestartVideo()
}
