//
//  ImageView.swift
//  Portfolio
//
//  Created by Marko Meseldzija on 4.2.24..
//

import SwiftUI

struct ImageView: View {
    let name: ImageResource
    let size: CGFloat
    
    var body: some View {
        Image(name)
            .resizable()
            .scaledToFit()
            .frame(width: size)
    }
}

#Preview {
    ImageView(name: .gemJewel, size: 30)
}
