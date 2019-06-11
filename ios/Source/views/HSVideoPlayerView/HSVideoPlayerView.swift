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
  private var backgroundQueue = DispatchQueue(label: "video player queue")

  @objc
  public var asset: AVAsset? {
    didSet {
      guard let asset = self.asset else {
        return
      }
      backgroundQueue.async {
        let item = AVPlayerItem(asset: asset, automaticallyLoadedAssetKeys: ["playable", "hasProtectedContent", "preferredTransform"])
        item.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: [.old, .new], context: nil)
        self.item = item
        self.player.replaceCurrentItem(with: item)
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidPlayToEnd(notification:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        self.play()
      }
    }
  }

  @objc
  private func playerDidPlayToEnd(notification _: NSNotification) {
    delegate?.videoPlayerDidRestartVideo()
  }

  override func observeValue(forKeyPath keyPath: String?, of _: Any?, change: [NSKeyValueChangeKey: Any]?, context _: UnsafeMutableRawPointer?) {
    if keyPath == #keyPath(AVPlayerItem.status) {
      var status: AVPlayerItem.Status
      if let statusNumber = change?[.newKey] as? NSNumber {
        if let _status = AVPlayerItem.Status(rawValue: statusNumber.intValue) {
          status = _status
        } else {
          status = .unknown
        }
      } else {
        status = .unknown
      }
      switch status {
      case .readyToPlay:
        onVideoDidBecomeReadyToPlay()
        return
      case .failed:
        onVideoDidFailToLoad()
        return
      case .unknown:
        return
      default:
        return
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
    delegate?.videoPlayerDidBecomeReadyToPlayAsset(asset)
    startTimeObvserver()
    DispatchQueue.main.async {
      switch orientation(forAsset: asset) {
      case .left, .leftMirrored, .right, .rightMirrored:
        self.playerLayer.videoGravity = .resizeAspect
        break
      default:
        self.playerLayer.videoGravity = .resizeAspectFill
        break
      }
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
        self?.delegate?.videoPlayerDidUpdatePlaybackTime(time, duration: asset.duration)
      }
    }
  }

  private func onVideoDidFailToLoad() {
    delegate?.videoPlayerDidFailToLoad()
  }
}
