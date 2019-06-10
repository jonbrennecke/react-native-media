import Photos

fileprivate let FETCH_LIMIT = 100

@objc
class HSMediaLibrary: NSObject {
  @objc
  public var delegate: HSMediaLibraryDelegate?

  @objc
  public func startObserving() {
    PHPhotoLibrary.shared().register(self)
  }

  @objc
  public func stopObserving() {
    PHPhotoLibrary.shared().unregisterChangeObserver(self)
  }

  @objc(loadAssets:)
  public func loadAssets(query: HSMediaLibraryQuery) -> [PHAsset] {
    let fetchOptions = PHFetchOptions()
    fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
    if #available(iOS 9.0, *) {
      fetchOptions.fetchLimit = FETCH_LIMIT
    }
    fetchOptions.wantsIncrementalChangeDetails = true
    let mediaType = query.mediaType.PHAssetMediaType
    let videoAssets = PHAsset.fetchAssets(with: mediaType, options: fetchOptions)
    return createArray(withFetchResult: videoAssets)
  }
}

extension HSMediaLibrary: PHPhotoLibraryChangeObserver {
  func photoLibraryDidChange(_: PHChange) {
    //    TODO:
//    let videos = loadAssets()
//    delegate?.mediaLibrary(didUpdateVideos: videos)
  }
}
