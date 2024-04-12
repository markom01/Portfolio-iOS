//
//  TechSectionView.swift
//  Portfolio
//
//  Created by Marko Meseldzija on 13.3.24..
//

import SwiftUI

struct TechSectionView: View {
    let title: String
    let technologies: [Tech]
    var isHeaderShown: Bool = true

    var body: SectionView<some View> {
        SectionView(
            header: title,
            isHeaderShown: isHeaderShown
        ) {
            ScrollStackView(axis: .horizontal, spacing: .small) {
                ForEach(technologies) { tech in
                    VStack {
                        if let urlString = tech.url, let url = URL(string: urlString) {
                            Link(destination: url) {
                                Text(tech.rawValue)
                            }
                        } else {
                            Button {} label: {
                                Text(tech.rawValue)
                            }
                            .allowsHitTesting(false)
                        }
                    }
                    .font(.callout)
                    .lineLimit(1)
                    .buttonStyle(.bordered)
                }
            }
        }
    }
}

#Preview {
    TechSectionView(title: "Tech stack", technologies: Constants.technologies)
}
