//
//  TechSectionView.swift
//  Portfolio
//
//  Created by Marko Meseldzija on 13.3.24..
//

import SwiftUI

struct TechSectionView: View {
    let title: String
    let technologies: [Skill]
    var isHeaderShown: Bool = true

    var body: SectionView<some View> {
        SectionView(
            header: title,
            isHeaderShown: isHeaderShown
        ) {
            ScrollStackView(axis: .horizontal, spacing: .small) {
                ForEach(technologies, id: \.rawValue) { tech in
                    VStack {
                        if let urlString = tech.url, let url = URL(string: urlString) {
                            Link(destination: url) { label(tech, isLink: true) }
                        } else {
                            Button {}
                        label: { label(tech, isLink: false) }
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

    func label(_ tech: Skill, isLink: Bool) -> some View {
        let imageSize: CGFloat = 20

        return HStack {
            Group {
                if let imageURLString = tech.imageURL {
                    ImageView(source: .url(imageURLString), size: imageSize)
                } else if isLink {
                    ImageView(source: .system("link"), size: imageSize)
                }
            }
            .cornerRadius(5)
            Text(tech.rawValue)
        }
    }
}

#Preview {
    TechSectionView(title: "Technologies", technologies: Constants.technologies)
}
