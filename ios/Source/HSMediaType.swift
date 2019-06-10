import Photos

enum HSMediaType {
  case video
  case image
  case any

  public static func from(string: String) -> HSMediaType? {
    switch string {
    case "video":
      return .video
    case "image":
      return .image
    case "any":
      return .any
    default:
      return .any
    }
  }

  public var PHAssetMediaType: PHAssetMediaType {
    switch self {
    case .video:
      return .video
    case .image:
      return .image
    case .any:
      return .unknown
    }
  }
}
