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

  @objc(loadAssets:)
  public func loadAssets(query: HSMediaLibraryQuery) -> [PHAsset] {
    let fetchOptions = PHFetchOptions()
    if let creationDateQuery = query.creationDateQuery {
      fetchOptions.predicate = creationDateQuery.predicate(forVariableNamed: "creationDate")
    }
    fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
    if #available(iOS 9.0, *) {
      fetchOptions.fetchLimit = query.limit
    }
    fetchOptions.wantsIncrementalChangeDetails = true
    let mediaType = query.mediaType.PHAssetMediaType
    if mediaType == .unknown {
      let videoAssets = PHAsset.fetchAssets(with: fetchOptions)
      return createArray(withFetchResult: videoAssets)
    } else {
      let videoAssets = PHAsset.fetchAssets(with: mediaType, options: fetchOptions)
      return createArray(withFetchResult: videoAssets)
    }
  }
}

extension HSMediaLibrary: PHPhotoLibraryChangeObserver {
  func photoLibraryDidChange(_: PHChange) {
//    delegate?.mediaLibraryDidChange()
  }
}
