import Photos
import UIKit

fileprivate let PREFETCH_THUMBNAIL_WIDTH: CGFloat = 25
fileprivate let PREFETCH_THUMBNAIL_SIZE = CGSize(width: PREFETCH_THUMBNAIL_WIDTH, height: PREFETCH_THUMBNAIL_WIDTH * 4 / 3)
fileprivate let SIZE_ZERO = CGSize(width: CGFloat.leastNonzeroMagnitude, height: CGFloat.leastNonzeroMagnitude)

class HSThumbnailView: UIView {
  private static let queue = DispatchQueue(label: "thumbnail loading queue")
  private static let imageManager = PHCachingImageManager()
  private let imageView = UIImageView()
  private let gradientLayer = CAGradientLayer()
  private var requestID: PHImageRequestID?

  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .black
    layer.masksToBounds = true
    imageView.frame = bounds
    gradientLayer.frame = bounds
    addSubview(imageView)
    layer.insertSublayer(gradientLayer, at: 0)
  }

  required init?(coder _: NSCoder) {
    fatalError("init?(coder: NSCoder) is not implemented.")
  }

  deinit {
    if let id = requestID {
      cancelLoadingThumbnail(requestID: id)
    }
  }

  @objc(startCachingImages:)
  public static func startCaching(images: [PHAsset]) {
    imageManager.startCachingImages(for: images,
                                    targetSize: PREFETCH_THUMBNAIL_SIZE,
                                    contentMode: .aspectFill,
                                    options: nil)
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    imageView.frame = bounds
    gradientLayer.frame = bounds
    loadThumbnail()
  }

  @objc
  public var asset: PHAsset? {
    didSet {
      loadThumbnail()
    }
  }
  
  @objc
  public var resizeCover: Bool = false {
    didSet {
      loadThumbnail()
    }
  }

  private func loadThumbnail() {
    guard let asset = asset else {
      return
    }
    let size = frame.size
    HSThumbnailView.queue.async { [weak self] in
      if size.width < SIZE_ZERO.width,
        size.height < SIZE_ZERO.height {
        self?.requestID = self?.loadThumbnail(asset: asset, targetSize: PREFETCH_THUMBNAIL_SIZE)
      }
      let targetSize = CGSize(width: size.width * UIScreen.main.scale, height: UIScreen.main.scale)
      self?.requestID = self?.loadThumbnail(asset: asset, targetSize: targetSize)
    }
  }

  private func loadThumbnail(asset: PHAsset, targetSize: CGSize) -> PHImageRequestID {
    let requestOptions = PHImageRequestOptions()
    requestOptions.isSynchronous = true
    requestOptions.resizeMode = .fast
    requestOptions.deliveryMode = .opportunistic
    let fullImageSize = CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
    let thumbnailOrientation = orientation(forSize: fullImageSize)
    return HSThumbnailView.imageManager.requestImage(
      for: asset,
      targetSize: targetSize,
      contentMode: .aspectFill,
      options: requestOptions
    ) { [weak self] image, _ in
      guard let image = image else {
        return
      }
      DispatchQueue.main.async {
        switch (self?.resizeCover ?? false, isLandscape(orientation: thumbnailOrientation)) {
        case (false, true):
          self?.imageView.contentMode = .scaleAspectFit
          self?.setLandscapeImageBackground(withImage: image)
          break
        default:
          self?.imageView.contentMode = .scaleAspectFill
        }
        self?.imageView.image = image
      }
    }
  }

  private func cancelLoadingThumbnail(requestID: PHImageRequestID) {
    PHImageManager.default().cancelImageRequest(requestID)
  }

  private func setLandscapeImageBackground(withImage image: UIImage) {
    HSThumbnailView.queue.async {
      let color = getMostFrequentColor(fromImage: image)
      DispatchQueue.main.async {
        self.gradientLayer.colors = [
          UIColor.black.withAlphaComponent(0).cgColor,
          UIColor.black.withAlphaComponent(0.5).cgColor,
        ]
        self.gradientLayer.locations = [0, 1]
        self.backgroundColor = color ?? .black
      }
    }
  }
}
