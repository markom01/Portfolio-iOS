//
//  ListView.swift
//  Portfolio
//
//  Created by Marko Meseldzija on 5.8.24..
//

import SwiftUI

struct ListScreen<T: View>: View {
    var bgImage: ImageResource?
    @ViewBuilder let content: T

    var body: some View {
        List {
            content
#if os(iOS)
                .listRowBackground(Rectangle().fill(.thinMaterial))
#endif
                .listRowSeparator(.hidden)
        }
        .removeListBg(image: bgImage)
#if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.ultraThinMaterial.opacity(0.1), for: .navigationBar, .tabBar)
        .toolbarBackground(.visible, for: .navigationBar, .tabBar)
#endif
//        .scrollBounceBehavior(.basedOnSize)
    }
}

#Preview {
    ListScreen {}
}
