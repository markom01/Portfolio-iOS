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
        switch source {
        case .url(let urlString):
            if let url = URL(string: urlString) {
                AsyncImage(url: url) {
                    $0.setup(size: size)
                } placeholder: {
                    Circle()
                        .frame(height: size)
                        .redacted(reason: .placeholder)
                        .foregroundStyle(.secondary.opacity(0.3))
                }
            }
        default:
            source.image?.setup(size: size)
        }
    }
}

extension ImageView {
    enum Source {
        case systemImage(String)
        case named(ImageResource)
        case url(String)

        var image: Image? {
            switch self {
            case .systemImage(let string): Image(systemName: string)
            case .named(let imageResource): Image(imageResource)
            case .url: nil
            }
        }
    }
}

#Preview {
    ImageView(source: .named(.gemJewel), size: 30)
}
