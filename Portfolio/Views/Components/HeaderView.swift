//
//  HeaderView.swift
//  Portfolio
//
//  Created by Marko Meseldzija on 10.3.24..
//

import SwiftUI

struct HeaderView: View {
    let isExpanded: Bool
    let headingView: AnyView
    let subHeadingView: AnyView
    let image: ImageResource
    var alignment: HorizontalAlignment? = .leading
    var rightImage: String?

    var body: some View {
        let layout = isExpanded
        ? AnyLayout(VStackLayout(spacing: .small))
        : AnyLayout(HStackLayout(alignment: .bottom, spacing: .small))

        return HStack {
            if isExpanded || alignment == .center {
                Spacer()
            }

            layout {
                ImageView(
                    source: .named(image),
                    size: isExpanded ? 100 : 50
                )
                VStack(alignment: isExpanded ? .center : .leading, spacing: 0) {
                    headingView
                        .font(isExpanded ? .title : .headline)
                        .fontWeight(.semibold)
                    HStack(spacing: 5) {
                        subHeadingView
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
            }

            Spacer()

            if !isExpanded, let rightImage {
                Image(systemName: rightImage)
                    .foregroundStyle(.accent)
                    .padding(.horizontal)
            }
        }
    }
}

#Preview {
    HeaderView(
        isExpanded: true,
        headingView: .init(Text("Heading")),
        subHeadingView: .init(Text("Subheading")),
        image: .gemJewel
    )
}
