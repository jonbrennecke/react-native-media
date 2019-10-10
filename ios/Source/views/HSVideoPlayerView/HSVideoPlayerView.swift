import AVFoundation
import UIKit

@available(iOS 10.0, *)
@objc
class HSVideoPlayerView: UIView {
  @objc
  public var delegate: HSVideoPlayerViewDelegate?

  private var item: AVPlayerItem?
  private var playerLooper: AVPlayerLooper?

  override class var layerClass: AnyClass {
    return AVPlayerLayer.self
  }

  private var playerLayer: AVPlayerLayer {
    return layer as! AVPlayerLayer
  }

  private var player = AVQueuePlayer()
  private var timeObserverToken: Any?
  private var backgroundQueue = DispatchQueue(
    label: "com.jonbrennecke.captionThis.videoPlayerQueue",
    qos: .userInitiated
  )

  @objc
  public var asset: AVAsset? {
    didSet {
      guard let asset = self.asset else {
        return
      }
      backgroundQueue.async { [weak self] in
        guard let strongSelf = self else { return }
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setCategory(.playback)
        try? audioSession.setActive(true, options: .init())
        let item = AVPlayerItem(asset: asset, automaticallyLoadedAssetKeys: [
          "playable", "hasProtectedContent", "preferredTransform",
        ])
        strongSelf.item = item
        strongSelf.player.replaceCurrentItem(with: item)
        strongSelf.player.addObserver(strongSelf, forKeyPath: #keyPath(AVPlayerItem.status), options: [.old, .new], context: nil)
        strongSelf.player.addObserver(strongSelf, forKeyPath: #keyPath(AVPlayer.timeControlStatus), options: [.old, .new], context: nil)
        NotificationCenter.default.addObserver(strongSelf, selector: #selector(strongSelf.playerDidPlayToEnd(notification:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
      }
    }
  }

  @objc
  private func playerDidPlayToEnd(notification _: NSNotification) {
    delegate?.videoPlayerViewWillRestartVideo(self)
  }

  override func observeValue(forKeyPath keyPath: String?, of _: Any?, change: [NSKeyValueChangeKey: Any]?, context _: UnsafeMutableRawPointer?) {
    if
      keyPath == #keyPath(AVPlayer.status),
      let statusRawValue = change?[.newKey] as? NSNumber,
      let status = AVPlayer.Status(rawValue: statusRawValue.intValue) {
      if case .readyToPlay = status {
        onVideoDidBecomeReadyToPlay()
      } else if case .failed = status {
        onVideoDidFailToLoad()
      }
    }

    if
      keyPath == #keyPath(AVPlayer.timeControlStatus),
      let newStatusRawValue = change?[.newKey] as? NSNumber,
      let oldStatusRawValue = change?[.oldKey] as? NSNumber,
      oldStatusRawValue != newStatusRawValue,
      let status = AVPlayer.TimeControlStatus(rawValue: newStatusRawValue.intValue) {
      switch status {
      case .waitingToPlayAtSpecifiedRate:
        delegate?.videoPlayer(view: self, didChangePlaybackState: .waiting)
      case .paused:
        delegate?.videoPlayer(view: self, didChangePlaybackState: .paused)
      case .playing:
        delegate?.videoPlayer(view: self, didChangePlaybackState: .playing)
        @unknown default:
        break
      }
    }
  }

  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    playerLayer.videoGravity = .resizeAspectFill
  }

  @objc
  public func play() {
    player.play()
  }

  @objc
  public func pause() {
    player.pause()
  }

  @objc
  public func restart(completionHandler: @escaping (Bool) -> Void) {
    seek(to: .zero, completionHandler: completionHandler)
  }

  @objc
  public func seek(to time: CMTime, completionHandler: @escaping (Bool) -> Void) {
    player.seek(to: time, completionHandler: completionHandler)
  }

  @objc
  public func stop() {
    player.pause()
    player.replaceCurrentItem(with: nil)
    if let timeObserverToken = timeObserverToken {
      player.removeTimeObserver(timeObserverToken)
      self.timeObserverToken = nil
    }
  }

  private func onVideoDidBecomeReadyToPlay() {
    guard let item = player.currentItem, let asset = player.currentItem?.asset else {
      return
    }
    playerLooper = AVPlayerLooper(player: player, templateItem: item)
    delegate?.videoPlayer(view: self, didChangePlaybackState: .readyToPlay)
    startTimeObvserver()
    DispatchQueue.main.async {
      self.playerLayer.videoGravity = isLandscape(orientation: orientation(forAsset: asset))
        ? .resizeAspect
        : .resizeAspectFill
      self.playerLayer.player = self.player
    }
  }

  private func startTimeObvserver() {
    guard let asset = asset else {
      return
    }
    backgroundQueue.async {
      let timeScale = CMTimeScale(NSEC_PER_SEC)
      let time = CMTime(seconds: 0.1, preferredTimescale: timeScale)
      self.timeObserverToken = self.player.addPeriodicTimeObserver(forInterval: time, queue: .main) {
        [weak self] time in
        guard let strongSelf = self else { return }
        strongSelf.delegate?.videoPlayer(
          view: strongSelf,
          didUpdatePlaybackTime: time,
          duration: asset.duration
        )
      }
    }
  }

  private func onVideoDidFailToLoad() {
    delegate?.videoPlayerViewDidFailToLoad(self)
  }
}
