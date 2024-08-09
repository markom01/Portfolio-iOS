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
#if os(iOS)
                    createLazyVGrid(columns: 2)
#elseif os(macOS)
                    createLazyVGrid(columns: 3)
                        .padding(.horizontal, .small)
#endif
                }
                .frame(height: imageHeight)
#if os(iOS)
                .tabViewStyle(.page)
#endif
                .listRowInsets(.init())
                .listRowBackground(Color.clear)
#if os(macOS)
                .onAppear { imageHeight = 500 }
#endif
            }
        }
    }

    struct Screenshot {
        let image: String
        var url: URL? { Bundle.main.url(forResource: image, withExtension: "png") }
    }

    @ViewBuilder
    func column(_ i: Int) -> some View {
        if let _url = images[safe: i]?.url {
            Button {  url = _url } label: {
                Group {
#if os(iOS)
                    if let image = UIImage(named: images[i].image) {
                        Image(uiImage: image)
                            .resizable()
                    }
#elseif os(macOS)
                    if let image = NSImage(named: images[i].image) {
                        Image(nsImage: image)
                            .resizable()
                    }
#endif
                }
                .scaledToFill()
                .clipShape(RoundedRectangle(cornerRadius: .small))
                .clipped()
#if os(iOS)
                .background {
                    GeometryReader { g in
                        Color.clear.onAppear {
                            if imageHeight == 0 {
                                imageHeight = g.size.height
                            }
                        }
                    }
                }
#endif
            }
        }
    }

    func createLazyVGrid(columns: Int) -> some View {
        ForEach(0..<images.count/columns + (images.count % 2 == 1 ? 1 : 0)) { i in
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: columns)) {
                ForEach(0..<columns) { j in
                    column(i * columns + j)
                }
            }
#if os(macOS)
            .tabItem {
                Text("\(i+1)")
            }
#elseif os(iOS)
            .padding(.horizontal, .xSmall)
#endif
        }
    }
}

#Preview {
    ProjectImagesTabView(images: [], url: .constant(nil))
}
