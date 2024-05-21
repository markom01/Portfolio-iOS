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
