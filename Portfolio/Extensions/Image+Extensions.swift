//
//  Image+Extensions.swift
//  Portfolio
//
//  Created by Marko Meseldzija on 14.3.24..
//

import SwiftUI

extension Image {
    func setup(size: CGFloat) -> some View {
        return self
            .resizable()
            .scaledToFit()
            .frame(width: size)
    }
}
