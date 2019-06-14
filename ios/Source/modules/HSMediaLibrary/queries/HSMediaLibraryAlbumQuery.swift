import Foundation

@objc
internal final class HSMediaLibraryAlbumQuery: HSMediaLibraryBasicQuery {
  internal let titleQuery: HSMediaLibraryTitleQuery?

  private init?(titleQuery: HSMediaLibraryTitleQuery?, dict: NSDictionary) {
    self.titleQuery = titleQuery
    super.init(dict: dict)
  }

  @objc
  public convenience override init?(dict: NSDictionary) {
    guard let titleQueryDict = dict["titleQuery"] as? NSDictionary? else {
      return nil
    }
    let titleQuery: HSMediaLibraryTitleQuery? = titleQueryDict != nil
      ? HSMediaLibraryTitleQuery.from(dict: titleQueryDict!)
      : nil
    self.init(titleQuery: titleQuery, dict: dict)
  }
}
