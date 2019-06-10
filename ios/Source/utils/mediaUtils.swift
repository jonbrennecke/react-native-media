import Photos

internal func createArray<T>(withFetchResult fetchResult: PHFetchResult<T>) -> [T] where T: AnyObject {
  var array = [T]()
  for i in 0 ..< fetchResult.count {
    let item = fetchResult.object(at: i)
    array.append(item)
  }
  return array
}
