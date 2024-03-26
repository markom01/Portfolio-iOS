//
//  TechSectionView.swift
//  Portfolio
//
//  Created by Marko Meseldzija on 13.3.24..
//

import SwiftUI

struct TechSectionView: View {
    let technologies: [Tech]
    var isHeaderShown: Bool = true

    var body: SectionView<some View> {
        SectionView(
            header: "Tech Stack",
            isHeaderShown: isHeaderShown
        ) {
            ScrollStackView(axis: .horizontal) {
                ForEach(technologies) { tech in
                    VStack {
                        Button {} label: {
                            Text(tech.rawValue)
                                .font(.callout)
                                .lineLimit(1)
                        }
                            .buttonStyle(.bordered)
                            .allowsHitTesting(false)
                    }
                }
            }
        }
    }
}

#Preview {
    TechSectionView(technologies: Constants.technologies)
}
