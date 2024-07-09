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

#if os(macOS)
    func removeListBg() -> some View {
        scrollContentBackground(.hidden)
        .listStyle(.sidebar)
        .background(.ultraThickMaterial)
    }
#endif

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
