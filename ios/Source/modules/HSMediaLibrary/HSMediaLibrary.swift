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
  public func queryAlbums(_ query: HSMediaLibraryAlbumQuery) -> [HSMediaAlbum] {
    let fetchOptions = PHFetchOptions()
    if #available(iOS 9.0, *) {
      fetchOptions.fetchLimit = query.limit
    }
    fetchOptions.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
    if let titleQuery = query.titleQuery {
      let predicate = titleQuery.predicate(forVariableNamed: "title")
      fetchOptions.predicate = predicate
    }
    let fetchResult = PHAssetCollection.fetchAssetCollections(
      with: .album,
      subtype: .any,
      options: fetchOptions
    )
//    let fetchResultFavorites = PHAssetCollection.fetchAssetCollections(
//      with: .smartAlbum,
//      subtype: .smartAlbumFavorites,
//      options: fetchOptions
//    )
//    let fetchResultCameraRoll = PHAssetCollection.fetchAssetCollections(
//      with: .smartAlbum,
//      subtype: .smartAlbumUserLibrary,
//      options: fetchOptions
//    )
    let collectionArray = createArray(withFetchResult: fetchResult)
//    let collectionArrayFavorites = createArray(withFetchResult: fetchResultFavorites)
//    let collectionArrayCameraRoll = createArray(withFetchResult: fetchResultCameraRoll)
    return [
      collectionArray,
//      collectionArrayFavorites,
//      collectionArrayCameraRoll,
    ].flatMap { $0 }.map { HSMediaAlbum(collection: $0) }
  }
}

extension HSMediaLibrary: PHPhotoLibraryChangeObserver {
  func photoLibraryDidChange(_: PHChange) {
//    delegate?.mediaLibraryDidChange()
  }
}
