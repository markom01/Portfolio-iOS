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
