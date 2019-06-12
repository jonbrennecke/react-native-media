import Photos

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

  @objc
  public func authorizeMediaLibrary(_ callback: @escaping (Bool) -> Void) {
    PHPhotoLibrary.requestAuthorization { status in
      switch status {
      case .authorized:
        return callback(true)
      case .denied, .notDetermined, .restricted:
        return callback(false)
        @unknown default:
        return callback(false)
      }
    }
  }

  @objc(queryMedia:)
  public func queryMedia(_ query: HSMediaLibraryMediaQuery) -> [HSMediaAsset] {
    let fetchOptions = PHFetchOptions()
    if let creationDateQuery = query.creationDateQuery {
      let predicate = creationDateQuery.predicate(forVariableNamed: "creationDate")
      fetchOptions.predicate = predicate
    }
    fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
    if #available(iOS 9.0, *) {
      fetchOptions.fetchLimit = query.limit
    }
    fetchOptions.wantsIncrementalChangeDetails = true
    let mediaType = query.mediaType.PHAssetMediaType
    let fetchResult = fetchAssets(in: query.albumID, with: mediaType, options: fetchOptions)
    let assets = createArray(withFetchResult: fetchResult)
    return assets.map { HSMediaAsset(asset: $0) }
  }

  @objc(queryAlbums:)
  public func queryAlbums(_ query: HSMediaLibraryBasicQuery) -> [HSMediaAlbum] {
    let fetchOptions = PHFetchOptions()
    fetchOptions.sortDescriptors = [NSSortDescriptor(key: "title", ascending: false)]
    if #available(iOS 9.0, *) {
      fetchOptions.fetchLimit = query.limit
    }
    let fetchResult = PHAssetCollection.fetchAssetCollections(
      with: .album,
      subtype: .albumRegular,
      options: fetchOptions
    )
    let collectionArray = createArray(withFetchResult: fetchResult)
    return collectionArray.map { HSMediaAlbum(collection: $0) }
  }
}

extension HSMediaLibrary: PHPhotoLibraryChangeObserver {
  func photoLibraryDidChange(_: PHChange) {
//    delegate?.mediaLibraryDidChange()
  }
}
