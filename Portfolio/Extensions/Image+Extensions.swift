//
//  Image+Extensions.swift
//  Portfolio
//
//  Created by Marko Meseldzija on 14.3.24..
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

extension Image {
    func setup(size: CGFloat, contentMode: ContentMode) -> some View {
        return self
            .resizable()
            .aspectRatio(contentMode: contentMode)
            .frame(width: size, height: size)
    }
}

#if canImport(UIKit)
extension UIImage {
    func dominantColors(isMultiple: Bool = true) -> [UIColor]? {
        guard let cgImage = self.cgImage else { return nil }

        let width = isMultiple ? 100 : 1
        let height = isMultiple ? 100 : 1
        let bitsPerComponent = 8
        let bytesPerPixel = 4
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue
        let pixels = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: width * height * bytesPerPixel)
        let context = CGContext(data: pixels, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerPixel * width, space: colorSpace, bitmapInfo: bitmapInfo)

        context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))

        var colorCounts: [UInt32: Int] = [:]

        for x in 0..<width {
            for y in 0..<height {
                let offset = (y * width + x) * bytesPerPixel
                let color = (UInt32(pixels[offset]) << 24) | (UInt32(pixels[offset+1]) << 16) | (UInt32(pixels[offset+2]) << 8) | UInt32(pixels[offset+3])
                if let count = colorCounts[color] {
                    colorCounts[color] = count + 1
                } else {
                    colorCounts[color] = 1
                }
            }
        }

        let sortedColors = colorCounts.sorted { $0.value > $1.value }

        let dominantColors: [UIColor] = sortedColors.prefix(isMultiple ? 5 : 1).map { (color: UInt32, _) in
            let r = CGFloat((color >> 24) & 255) / 255.0
            let g = CGFloat((color >> 16) & 255) / 255.0
            let b = CGFloat((color >> 8) & 255) / 255.0
            let a = CGFloat(color & 255) / 255.0
            return UIColor(red: r, green: g, blue: b, alpha: a)
        }

        return dominantColors
    }
}
#endif
