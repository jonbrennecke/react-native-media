import AVFoundation

@available(iOS 10.0, *)
@objc
protocol HSVideoPlayerViewDelegate {
  @objc(videoPlayerViewDidFailToLoad:)
  func videoPlayerViewDidFailToLoad(_ view: HSVideoPlayerView)

  @objc(videoPlayerView:didUpdatePlaybackTime:duration:)
  func videoPlayer(view: HSVideoPlayerView, didUpdatePlaybackTime time: CMTime, duration: CMTime)

  @objc(videoPlayerViewWillRestartVideo:)
  func videoPlayerViewWillRestartVideo(_ view: HSVideoPlayerView)

  @objc(videoPlayerView:didChangePlaybackState:)
  func videoPlayer(view: HSVideoPlayerView, didChangePlaybackState playbackState: HSVideoPlaybackState)
}
