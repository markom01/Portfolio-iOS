//
//  ProjectImagesTabView.swift
//  Portfolio
//
//  Created by Marko Meseldzija on 29.7.24..
//

import SwiftUI

struct ProjectImagesTabView: View {
    let images: [Screenshot]
    @Binding var url: URL?
    @State var imageHeight: CGFloat = 0

    var body: some View {
        if !images.isEmpty {
            Section("Screenshots") {
                TabView {
                    ForEach(0..<images.count/2) { i in
                        LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 2)) {
                            column(i*2)
                            column(i*2+1)
                        }
                    }
                }
                .frame(height: imageHeight)
                .tabViewStyle(.page)
                .listRowInsets(.init())
                .listRowBackground(Color.clear)
            }
        }
    }

    struct Screenshot {
        let image: String
        var url: URL? { Bundle.main.url(forResource: image, withExtension: "png") }
    }

    @ViewBuilder
    func column(_ i: Int) -> some View {
        if let _url = images[i].url {
            Button {  url = _url } label: {
                if let uiImage = UIImage(named: images[i].image) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .clipShape(RoundedRectangle(cornerRadius: .small))
                        .clipped()
                        .background {
                            GeometryReader { g in
                                Color.clear.onAppear {
                                    if imageHeight == 0 {
                                        imageHeight = g.size.height
                                    }
                                }
                            }
                        }
                }
            }
        }
    }
}

#Preview {
    ProjectImagesTabView(images: [], url: .constant(nil))
}
