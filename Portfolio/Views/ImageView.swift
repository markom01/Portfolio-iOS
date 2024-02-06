//
//  ImageView.swift
//  Portfolio
//
//  Created by Marko Meseldzija on 4.2.24..
//

import SwiftUI

struct ImageView: View {
    let source: Source
    let size: CGFloat
    
    var body: some View {
        source.image
            .resizable()
            .scaledToFit()
            .frame(width: size)
    }
    
    enum Source {
        case systemImage(String)
        case named(ImageResource)
        
        var image: Image {
            switch self {
            case .systemImage(let string): Image(systemName: string)
            case .named(let imageResource): Image(imageResource)
            }
        }
    }
}

#Preview {
    ImageView(source: .named(.gemJewel), size: 30)
}
