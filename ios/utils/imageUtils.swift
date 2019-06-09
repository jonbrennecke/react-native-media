import UIKit

// SEE: https://gist.github.com/Tricertops/6474123
internal func getMostFrequentColor(fromImage image: UIImage) -> UIColor? {
    guard let cgImage = image.cgImage else {
        return nil
    }
    let bitmapData = rgbBitmapData(fromImage: cgImage)
    let colorHistogram = bitmapData.withUnsafeBytes { (bytes: UnsafePointer<UInt8>) -> ColorHistogram in
        let colorHistogram = ColorHistogram()
        for i in stride(from: 0, to: bitmapData.count, by: 4) {
            colorHistogram.insertColor(
                red: CGFloat(bytes[i]) / 255,
                green: CGFloat(bytes[i + 1]) / 255,
                blue: CGFloat(bytes[i + 2]) / 255
            )
        }
        return colorHistogram
    }
    let sortedColors = colorHistogram.sortedColors()
    return sortedColors.first
}

fileprivate func rgbBitmapData(fromImage image: CGImage) -> Data {
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue)
    let scale: CGFloat = 0.25
    let size = CGSize(width: CGFloat(image.width) * scale, height: CGFloat(image.height) * scale)
    let bytesPerPixel = 4
    let bitsPerComponent = 8
    let bytesPerRow = bytesPerPixel * Int(size.width)
    var bitmapData = Data(count: Int(size.height * size.width * CGFloat(bytesPerPixel)))
    bitmapData.withUnsafeMutableBytes { (bytes: UnsafeMutablePointer<UInt8>) -> Void in
        let context = CGContext(
            data: bytes,
            width: Int(size.width),
            height: Int(size.height),
            bitsPerComponent: bitsPerComponent,
            bytesPerRow: bytesPerRow,
            space: colorSpace,
            bitmapInfo: bitmapInfo.rawValue
        )
        let rect = CGRect(origin: .zero, size: size)
        context?.draw(image, in: rect)
    }
    return bitmapData
}
