import UIKit

@objc(FRGOFarragoExampleView)
class FarragoExampleView: UIView {
  private let label = UILabel()

  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    super.didMoveToWindow()
    label.frame = bounds
    label.text = "Hello World!"
    label.textAlignment = .center
    label.backgroundColor = .red
    label.sizeToFit()
    addSubview(label)
  }
}
