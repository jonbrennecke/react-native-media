import UIKit

internal class HSColorHistogram {
  private let numberOfBins: Int
  private let countedSet: NSCountedSet

  init(numberOfBins: Int = 100) {
    self.numberOfBins = numberOfBins
    countedSet = NSCountedSet(capacity: numberOfBins * 3)
  }

  public func insertColor(red: CGFloat, green: CGFloat, blue: CGFloat) {
    let color = binnedColor(red: red, green: green, blue: blue)
    countedSet.add(color)
  }

  public func sortedColors() -> [UIColor] {
    return countedSet.sorted { (a, b) -> Bool in
      countedSet.count(for: a) < countedSet.count(for: b)
    } as! [UIColor]
  }

  private func binnedColor(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
    let numberOfBinsFloat = CGFloat(numberOfBins)
    let r = (red * numberOfBinsFloat).rounded() / numberOfBinsFloat
    let g = (green * numberOfBinsFloat).rounded() / numberOfBinsFloat
    let b = (blue * numberOfBinsFloat).rounded() / numberOfBinsFloat
    return UIColor(
      red: r,
      green: g,
      blue: b,
      alpha: 1
    )
  }
}
