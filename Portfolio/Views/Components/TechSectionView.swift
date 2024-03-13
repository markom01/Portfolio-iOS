//
//  TechSectionView.swift
//  Portfolio
//
//  Created by Marko Meseldzija on 13.3.24..
//

import SwiftUI

struct TechSectionView: View {
    let scrollPagerManager = ScrollManager.Pager()
    let technologies: [Tech]
    var isHeaderShown: Bool = true

    var body: SectionView<ScrollStackView<some View>> {
        SectionView(
            header: "Tech Stack",
            isHeaderShown: isHeaderShown
        ) {
            ScrollStackView(axis: .horizontal, delegate: scrollPagerManager) {
                ForEach(technologies) { tech in
                    VStack {
                        ImageView(source: .named(tech.image), size: 50)
                        Text(tech.rawValue).font(.callout)
                    }
                }
            }
        }
    }
}

#Preview {
    TechSectionView(technologies: [.swiftui, .uikit])
}
