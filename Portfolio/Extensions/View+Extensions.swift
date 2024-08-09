//
//  View+Extensions.swift
//  Portfolio
//
//  Created by Marko Meseldzija on 27.3.24..
//

import SwiftUI

extension View {
    func backButton(_ selectedId: Binding<UUID?>) -> some View {
        self.modifier(BackButtonModifier(selectedId: selectedId))
    }

    func removeListBg(image: ImageResource? = nil) -> some View {
        scrollContentBackground(.hidden)
#if os(macOS)
        .background(.ultraThinMaterial)
#endif
        .background {
            if let image {
                Image(image)
                    .resizable()
                    .scaledToFill()
#if os(iOS)
                    .ignoresSafeArea(.all)
                    .blurOverlay()
#elseif os(macOS)
                    .overlay(.thickMaterial)
#endif
            }
        }
        .clipped()
    }

    func blurOverlay() -> some View {
        overlay(.thinMaterial)
            .overlay(.thinMaterial)
            .overlay(.black.opacity(0.1))
    }

    func reverseMask<Mask: View>(
        alignment: Alignment = .center,
        @ViewBuilder _ mask: () -> Mask
    ) -> some View {
        self.mask {
            Rectangle()
                .overlay(alignment: alignment) {
                    mask()
                        .blendMode(.destinationOut)
                }
        }
    }
}

struct BackButtonModifier: ViewModifier {
    @Binding var selectedId: UUID?

    func body(content: Content) -> some View {
        content
            .toolbar {
                if selectedId != nil {
                    ToolbarItem { Spacer() }
                    ToolbarItem(placement: Constants.backPlacement) {
                        Button("", systemImage: "chevron.left") { selectedId = nil }
                    }
                }
            }
    }
}
