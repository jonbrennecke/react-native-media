import Photos
import UIKit

fileprivate let THUMBNAIL_WIDTH: CGFloat = 100
fileprivate let THUMBNAIL_SIZE = CGSize(width: THUMBNAIL_WIDTH, height: THUMBNAIL_WIDTH * 4 / 3)

class HSThumbnailView: UIView {
  private static let queue = DispatchQueue(label: "thumbnail loading queue")
  private static let imageManager = PHCachingImageManager()
  private let imageView = UIImageView()
  private var requestID: PHImageRequestID?

  override init(frame: CGRect) {
    super.init(frame: frame)
    imageView.frame = frame
    addSubview(imageView)
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
                                    targetSize: THUMBNAIL_SIZE,
                                    contentMode: .aspectFill,
                                    options: nil)
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    imageView.frame = frame
  }

  @objc
  public var asset: PHAsset? {
    didSet {
      guard let asset = self.asset else {
        return
      }
      HSThumbnailView.queue.async { [weak self] in
        self?.requestID = self?.loadThumbnail(forAsset: asset, withSize: THUMBNAIL_SIZE)
      }
    }
  }

  private func loadThumbnail(forAsset asset: PHAsset, withSize size: CGSize) -> PHImageRequestID {
    let requestOptions = PHImageRequestOptions()
    requestOptions.isSynchronous = false
    requestOptions.resizeMode = .fast
    requestOptions.deliveryMode = .opportunistic
    let pixelSize = CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
    let orientation = imageOrientation(forSize: pixelSize)
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
      let gradientLayer = CAGradientLayer()
      gradientLayer.colors = [
        UIColor.black.withAlphaComponent(0).cgColor,
        UIColor.black.withAlphaComponent(0.5).cgColor,
      ]
      gradientLayer.locations = [0, 1]
      DispatchQueue.main.async {
        gradientLayer.frame = self.bounds
        self.backgroundColor = color ?? .black
        self.layer.insertSublayer(gradientLayer, at: 0)
      }
    }
  }
}
