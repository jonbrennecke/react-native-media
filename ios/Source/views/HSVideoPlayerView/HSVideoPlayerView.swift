import AVFoundation
import UIKit

@available(iOS 10.0, *)
@objc
class HSVideoPlayerView: UIView {
  @objc
  public weak var delegate: HSVideoPlayerViewDelegate?

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
  private var delegateQueue = DispatchQueue(
    label: "com.jonbrennecke.captionThis.videoPlayer.delegateQueue",
    qos: .userInteractive
  )

  deinit {
    if let token = timeObserverToken {
      player.removeTimeObserver(token)
    }
  }

  private func startTimeObvserver() {
    guard let asset = asset else {
      return
    }
    backgroundQueue.async { [weak self] in
      guard let strongSelf = self else { return }
      let timeScale = CMTimeScale(NSEC_PER_SEC)
      let time = CMTime(seconds: 1 / 30, preferredTimescale: timeScale)
      if let token = strongSelf.timeObserverToken {
        strongSelf.player.removeTimeObserver(token)
      }
      strongSelf.timeObserverToken = strongSelf.player.addPeriodicTimeObserver(
        forInterval: time, queue: strongSelf.delegateQueue
      ) {
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

  // MARK: - UIView methods

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

  // MARK: - public objc interface

  @objc
  public var asset: AVAsset? {
    didSet {
      guard let asset = self.asset else {
        return
      }
      backgroundQueue.async { [weak self] in
        guard let strongSelf = self else { return }
        let item = AVPlayerItem(asset: asset)
        strongSelf.item = item
        strongSelf.player.replaceCurrentItem(with: item)
        strongSelf.player.actionAtItemEnd = .pause
        strongSelf.player.addObserver(strongSelf, forKeyPath: #keyPath(AVPlayerItem.status), options: [.old, .new], context: nil)
        strongSelf.player.addObserver(strongSelf, forKeyPath: #keyPath(AVPlayer.timeControlStatus), options: [.old, .new], context: nil)
        NotificationCenter.default.addObserver(
          strongSelf,
          selector: #selector(strongSelf.onVideoDidPlayToEnd(notification:)),
          name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
          object: strongSelf.item
        )
      }
    }
  }

  @objc
  public func play() {
    let audioSession = AVAudioSession.sharedInstance()
    try? audioSession.setCategory(.playback)
    try? audioSession.setActive(true, options: .init())
    player.play()
  }

  @objc
  public func pause() {
    player.pause()
  }

  @objc
  public func restart(completionHandler: @escaping (Bool) -> Void) {
    seek(to: CMTime(seconds: 0, preferredTimescale: 600)) { [weak self] success in
      if success {
        self?.play()
      }
      completionHandler(success)
    }
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

  // MARK: - video events

  private func onVideoDidBecomeReadyToPlay() {
    guard let asset = player.currentItem?.asset else {
      return
    }
    delegate?.videoPlayer(view: self, didChangePlaybackState: .readyToPlay)
    startTimeObvserver()
    DispatchQueue.main.async { [weak self] in
      guard let strongSelf = self else { return }
      strongSelf.playerLayer.videoGravity = isLandscape(orientation: orientation(forAsset: asset))
        ? .resizeAspect
        : .resizeAspectFill
      strongSelf.playerLayer.player = strongSelf.player
    }
  }

  private func onVideoDidFailToLoad() {
    delegate?.videoPlayerViewDidFailToLoad(self)
  }

  @objc
  private func onVideoDidPlayToEnd(notification _: NSNotification) {
    delegate?.videoPlayerViewDidPlayToEnd(self)
  }
}
