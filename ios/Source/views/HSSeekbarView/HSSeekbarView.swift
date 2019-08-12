import Photos
import UIKit

class HSSeekbarView: UIView {
  private static let imageManager = PHCachingImageManager()

  private var imageViews: [UIImageView] = []
  private var requestID: PHImageRequestID?

  private var assetImageGenerator: AVAssetImageGenerator? {
    willSet {
      assetImageGenerator?.cancelAllCGImageGeneration()
    }
  }

  deinit {
    if let id = requestID {
      cancelLoadingVideo(requestID: id)
    }
  }

  private func cancelLoadingVideo(requestID: PHImageRequestID) {
    HSSeekbarView.imageManager.cancelImageRequest(requestID)
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    layoutImageViews()
    loadImages()
  }

  private func layoutImageViews() {
    let (size, numberOfImages) = createSeekbarConfig(size: frame.size)

    // delete extra imageViews
    while imageViews.count > numberOfImages {
      _ = imageViews.popLast()
    }

    // layout imageViews
    for i in 0 ..< numberOfImages {
      let imageView = getOrCreateImageView(at: i)
      let origin = CGPoint(x: size.width * CGFloat(i), y: 0)
      imageView.frame = CGRect(origin: origin, size: size)
    }
  }

  @objc
  public var asset: PHAsset? {
    didSet {
      layoutImageViews()
      loadImages()
    }
  }

  private func loadImages() {
    guard let asset = asset else {
      return
    }
    let videoRequestOptions = PHVideoRequestOptions()
    videoRequestOptions.deliveryMode = .automatic
    requestID = HSSeekbarView.imageManager.requestAVAsset(
      forVideo: asset,
      options: videoRequestOptions
    ) { avAsset, _, _ in
      DispatchQueue.main.async { [weak self] in
        guard let avAsset = avAsset else {
          return
        }
        self?.generateImages(withAsset: avAsset)
      }
    }
  }

  private func generateImages(withAsset asset: AVAsset) {
    assetImageGenerator = AVAssetImageGenerator(asset: asset)
    guard let generator = assetImageGenerator else { return }
    generator.appliesPreferredTrackTransform = true
    let duration = CMTimeGetSeconds(asset.duration)
    let (size, numberOfImages) = createSeekbarConfig(size: frame.size)
    let times = createSeekbarTimeValues(numberOfImages: numberOfImages, duration: duration)
    let scale = UIScreen.main.scale
    generator.maximumSize = CGSize(width: size.width * scale, height: size.height * scale)
    generator.appliesPreferredTrackTransform = true
    generator.cancelAllCGImageGeneration()
    generator.generateCGImagesAsynchronously(forTimes: times) { requestedTime, cgImage, _, _, error in
      if error != nil {
        return
      }
      guard let cgImage = cgImage else {
        return
      }
      let image = UIImage(cgImage: cgImage)
      guard let index = times.firstIndex(of: requestedTime as NSValue) else {
        return
      }
      DispatchQueue.main.async { [weak self] in
        self?.set(image, at: index)
      }
    }
  }

  private func set(_ image: UIImage, at index: Int) {
    let imageView = getOrCreateImageView(at: index)
    imageView.image = image
    switch image.imageOrientation {
    case .left, .right, .leftMirrored, .rightMirrored:
      imageView.contentMode = .scaleAspectFit
      break
    default:
      imageView.contentMode = .scaleAspectFill
      break
    }
  }

  private func getOrCreateImageView(at index: Int) -> UIImageView {
    guard index < imageViews.count else {
      let imageView = UIImageView()
      imageView.layer.masksToBounds = true
      imageViews.append(imageView)
      addSubview(imageView)
      return imageView
    }
    return imageViews[index]
  }
}
