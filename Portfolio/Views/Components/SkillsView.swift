//
//  SkillsView.swift
//  Portfolio
//
//  Created by Marko Meseldzija on 13.3.24..
//

import SwiftUI

struct SkillsView: View {
    let technologies: [Skill]
    var adjustEdgeInsets = false

    var body: some View {
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
#if os(macOS)
                .controlSize(technologies is [Libraries] ? .large : .regular)
#endif
            }
        }
        .padding(.vertical, .xSmall)
        .listRowInsets(adjustEdgeInsets ? .init(top: .small, leading: 0, bottom: .small, trailing: 16) : nil)
    }

    func label(_ tech: Skill, isLink: Bool) -> some View {
        let imageSize: CGFloat = 20

        return HStack {
            Group {
                if let imageURLString = tech.imageURL {
                    ImageView(source: .url(imageURLString), size: imageSize)
                } else if isLink {
                    ImageView(source: .system("link"), size: 15)
                }
            }
            .cornerRadius(5)
            Text(tech.rawValue)
        }
    }
}

#Preview {
    SkillsView(technologies: Constants.technologies)
}
