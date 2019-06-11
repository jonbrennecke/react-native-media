import Photos

enum HSMediaType {
  case video
  case image
  case any

  public static func from(string: String) -> HSMediaType {
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

  public static func from(assetMediaType mediaType: PHAssetMediaType) -> HSMediaType {
    switch mediaType {
    case .video:
      return .video
    case .image:
      return .image
    case .unknown:
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

  public var stringValue: String {
    switch self {
    case .video:
      return "video"
    case .image:
      return "image"
    case .any:
      return "any"
    }
  }
}
