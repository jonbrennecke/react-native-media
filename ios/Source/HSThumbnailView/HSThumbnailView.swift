import Photos
import UIKit

fileprivate let DEFAULT_THUMBNAIL_WIDTH: CGFloat = 100
fileprivate let DEFAULT_THUMBNAIL_SIZE = CGSize(width: DEFAULT_THUMBNAIL_WIDTH, height: DEFAULT_THUMBNAIL_WIDTH * 4 / 3)

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
                                    targetSize: DEFAULT_THUMBNAIL_SIZE,
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

  private func loadThumbnail() {
    guard let asset = asset else {
      return
    }
    let size = frame.size
    HSThumbnailView.queue.async { [weak self] in
      self?.requestID = self?.loadThumbnail(forAsset: asset, withSize: size)
    }
  }

  private func loadThumbnail(forAsset asset: PHAsset, withSize size: CGSize) -> PHImageRequestID {
    let requestOptions = PHImageRequestOptions()
    requestOptions.isSynchronous = false
    requestOptions.resizeMode = .fast
    requestOptions.deliveryMode = .opportunistic
    let originalPixelSize = CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
    let orientation = imageOrientation(forSize: originalPixelSize)
    return HSThumbnailView.imageManager.requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: requestOptions) { [weak self] image, _ in
      guard let image = image else {
        return
      }
      DispatchQueue.main.async {
        switch orientation {
        case .right, .rightMirrored, .left, .leftMirrored:
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
