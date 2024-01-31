//
//  SectionView.swift
//  Portfolio
//
//  Created by Marko Meseldzija on 31.1.24..
//

import SwiftUI

struct SectionView: View {
    let data: Data
    let isHeaderShown: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            if isHeaderShown {
                Text(data.title).font(.title2)
            }
            Text(data.text).lineLimit(isHeaderShown ? nil : 2)
        }
    }
}

extension SectionView {
    struct Data {
        let title: String
        let text: String
    }
}

#Preview {
    SectionView(
        data: .init(
            title: "Title",
            text: "Morbi lacinia lobortis magna nec commodo. Fusce faucibus ipsum felis, ac egestas nisi aliquam varius. Donec sed elementum turpis. Maecenas suscipit fermentum orci nec pretium. Nam at orci orci. Proin sodales"
        ), 
        isHeaderShown: true
    )
}
