import Photos

@objc
protocol HSMediaLibraryDelegate {
  func mediaLibrary(didGenerateThumbnail thumbnail: UIImage, size: CGSize)
  func mediaLibrary(didUpdateVideos videos: [PHAsset])
}
