//
//  Image+Extensions.swift
//  Portfolio
//
//  Created by Marko Meseldzija on 14.3.24..
//

import SwiftUI

extension Image {
    func setup(size: CGFloat, contentMode: ContentMode) -> some View {
        return self
            .resizable()
            .aspectRatio(contentMode: contentMode)
            .frame(width: size, height: size)
    }
}

extension UIImage {
    func dominantColor() -> UIColor? {
        guard let cgImage else { return nil }
        let width = 1
        let height = 1
        let bitsPerComponent = 8
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * width
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue
        var pixelData = [UInt8](repeating: 0, count: width * height * bytesPerPixel)

        guard let context = CGContext(data: &pixelData, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo) else { return nil }

        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))

        let red = CGFloat(pixelData[0]) / 255.0
        let green = CGFloat(pixelData[1]) / 255.0
        let blue = CGFloat(pixelData[2]) / 255.0
        let alpha = CGFloat(pixelData[3]) / 255.0

        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
