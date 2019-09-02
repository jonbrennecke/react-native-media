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

  deinit {
    stopObserving()
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
    return createArray(withFetchResult: fetchResult)
      .map { HSMediaAlbum(collection: $0) }
  }

  @objc(createAlbumWithTitle:completionHandler:)
  public func createAlbum(withTitle title: String, _ completionHandler: @escaping (HSMediaAlbum?) -> Void) {
    let fetchOptions = PHFetchOptions()
    if #available(iOS 9.0, *) {
      fetchOptions.fetchLimit = 1
    }
    fetchOptions.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
    fetchOptions.predicate = NSPredicate(format: "title = %@", title)
    let fetchResult = PHAssetCollection.fetchAssetCollections(
      with: .album, subtype: .any, options: fetchOptions
    )
    if let collection = fetchResult.firstObject {
      let album = HSMediaAlbum(collection: collection)
      completionHandler(album)
      return
    }
    var albumPlaceholder: PHObjectPlaceholder?
    PHPhotoLibrary.shared().performChanges({
      let albumChangeRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(
        withTitle: title
      )
      albumPlaceholder = albumChangeRequest.placeholderForCreatedAssetCollection
    }) { [weak self] (success, _) -> Void in
      guard self != nil else { return }
      if !success {
        completionHandler(nil)
        return
      }
      guard let placeholder = albumPlaceholder else {
        completionHandler(nil)
        return
      }
      let fetchResult = PHAssetCollection.fetchAssetCollections(
        withLocalIdentifiers: [placeholder.localIdentifier], options: nil
      )
      if let collection = fetchResult.firstObject {
        let album = HSMediaAlbum(collection: collection)
        completionHandler(album)
        return
      }
      completionHandler(nil)
    }
  }

  @objc(createAssetWithFileAtURL:albumID:completionHandler:)
  public func createAsset(
    withFileAtURL url: URL,
    albumID: String?,
    _ completionHandler: @escaping (HSMediaAsset?) -> Void
  ) {
    PHPhotoLibrary.shared().performChanges({
      let creationRequest = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
      guard let placeholder = creationRequest?.placeholderForCreatedAsset else {
        completionHandler(nil)
        return
      }
      let assetFetchRequest = PHAsset.fetchAssets(
        withLocalIdentifiers: [placeholder.localIdentifier], options: nil
      )
      guard let asset = assetFetchRequest.firstObject else {
        completionHandler(nil)
        return
      }
      if let albumID = albumID {
        let collectionFetchResult = PHAssetCollection.fetchAssetCollections(
          withLocalIdentifiers: [albumID], options: nil
        )
        if let collection = collectionFetchResult.firstObject {
          let collectionChangeRequest = PHAssetCollectionChangeRequest(for: collection)
          collectionChangeRequest?.addAssets(assetFetchRequest)
        }
      }
      completionHandler(HSMediaAsset(asset: asset))
    })
  }

  @objc
  public func getFavoritesAlbum() -> HSMediaAlbum? {
    let fetchResult = PHAssetCollection.fetchAssetCollections(
      with: .smartAlbum,
      subtype: .smartAlbumFavorites,
      options: nil
    )
    guard let collection = fetchResult.firstObject else {
      return nil
    }
    return HSMediaAlbum(collection: collection)
  }

  @objc
  public func getCameraRollAlbum() -> HSMediaAlbum? {
    let fetchResult = PHAssetCollection.fetchAssetCollections(
      with: .smartAlbum,
      subtype: .smartAlbumUserLibrary,
      options: nil
    )
    guard let collection = fetchResult.firstObject else {
      return nil
    }
    return HSMediaAlbum(collection: collection)
  }
}

extension HSMediaLibrary: PHPhotoLibraryChangeObserver {
  func photoLibraryDidChange(_: PHChange) {
    delegate?.mediaLibraryDidChange()
  }
}
