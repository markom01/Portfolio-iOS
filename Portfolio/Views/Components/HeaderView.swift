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
    let imageSource: ImageView.Source
    var alignment: HorizontalAlignment? = .leading
    var rightImage: String?

    var body: some View {
        let layout = isExpanded
        ? AnyLayout(VStackLayout(spacing: .small))
        : AnyLayout(HStackLayout(spacing: .small))

        return HStack {
            if isExpanded || alignment == .center {
                Spacer()
            }

            layout {
                ImageView(
                    source: imageSource,
                    size: isExpanded ? 100 : 35
                )
                VStack(alignment: isExpanded ? .center : .leading) {
                    headingView
                        .font(isExpanded ? .title : .headline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                    subHeadingView
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
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
        isExpanded: false,
        headingView: .init(Text("Heading")),
        subHeadingView: .init(Text("Subheading")),
        imageSource: .named(.gemJewel)
    )
}
