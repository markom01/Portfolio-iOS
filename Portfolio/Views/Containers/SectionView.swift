//
//  SectionView.swift
//  Portfolio
//
//  Created by Marko Meseldzija on 31.1.24..
//

import SwiftUI

struct SectionView<T: View>: View {
    let header: String
    var isHeaderShown: Bool? = true
    @ViewBuilder let content: T

    var body: some View {
        VStack(alignment: .leading, spacing: .medium) {
            if isHeaderShown ?? true {
                Text(header.capitalized)
                    .font(.title2)
                    .fontWeight(.medium)
                    .foregroundStyle(.primary)
            }
            content
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    SectionView(
        header: "Title",
        isHeaderShown: true
    ) {
        Text(Constants.placholderParagraph)
    }
}
