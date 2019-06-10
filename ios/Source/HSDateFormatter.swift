import Foundation

internal class HSDateFormatter {
  @available(iOS 10.0, *)
  private static let formatter = ISO8601DateFormatter()

  public static func string(from date: Date) -> String? {
    if #available(iOS 10, *) {
      return formatter.string(from: date)
    } else {
      return nil // TODO: support < iOS 10
    }
  }

  public static func date(from string: String) -> Date? {
    if #available(iOS 10, *) {
      return formatter.date(from: string)
    } else {
      return nil // TODO: support < iOS 10
    }
  }
}
