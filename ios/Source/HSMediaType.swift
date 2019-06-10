import Photos

enum HSMediaType {
  case video
  case image

  public static func from(string: String) -> HSMediaType? {
    switch string {
    case "video":
      return .video
    case "image":
      return .image
    default:
      return nil
    }
  }

  public var PHAssetMediaType: PHAssetMediaType {
    switch self {
    case .video:
      return .video
    case .image:
      return .image
    }
  }
}
