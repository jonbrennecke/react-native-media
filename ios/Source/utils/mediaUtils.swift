import Photos

internal func createArray<T>(withFetchResult fetchResult: PHFetchResult<T>) -> [T] where T: AnyObject {
  var array = [T]()
  for i in 0 ..< fetchResult.count {
    let item = fetchResult.object(at: i)
    array.append(item)
  }
  return array
}

internal func fetchAssets(in albumID: String?, with mediaType: PHAssetMediaType, options: PHFetchOptions) -> PHFetchResult<PHAsset> {
  guard let albumID = albumID, let collection = fetchAssetCollection(with: albumID) else {
    return mediaType == .unknown
      ? PHAsset.fetchAssets(with: options)
      : PHAsset.fetchAssets(with: mediaType, options: options)
  }
  if mediaType != .unknown {
    let mediaTypePredicate = NSPredicate(format: "mediaType = %d", argumentArray: [mediaType.rawValue])
    options.predicate = options.predicate != nil
      ? NSCompoundPredicate(andPredicateWithSubpredicates: [
        options.predicate!,
        mediaTypePredicate,
      ])
      : mediaTypePredicate
  }
  return PHAsset.fetchAssets(in: collection, options: options)
}

fileprivate func fetchAssetCollection(with id: String) -> PHAssetCollection? {
  return PHAssetCollection.fetchAssetCollections(
    withLocalIdentifiers: [id], options: nil
  ).firstObject
}
