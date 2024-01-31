//
//  SectionView.swift
//  Portfolio
//
//  Created by Marko Meseldzija on 31.1.24..
//

import SwiftUI

struct SectionView<T: View>: View {
    let header: String
    let isHeaderShown: Bool
    @ViewBuilder let content: T

    var body: some View {
        VStack(alignment: .leading, spacing: .constant(.medium)) {
            if isHeaderShown {
                Text(header).font(.title2)
            }
            content
        }
    }
}

#Preview {
    SectionView(
        header: "Title",
        isHeaderShown: true
    ) {
        Text("Morbi lacinia lobortis magna nec commodo. Fusce faucibus ipsum felis, ac egestas nisi aliquam varius. Donec sed elementum turpis. Maecenas suscipit fermentum orci nec pretium. Nam at orci orci. Proin sodales")
    }
}
