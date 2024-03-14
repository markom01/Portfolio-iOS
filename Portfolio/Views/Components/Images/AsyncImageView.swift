//
//  AsyncImageView.swift
//  Portfolio
//
//  Created by Marko Meseldzija on 14.3.24..
//

import SwiftUI

struct AsyncImageView: View {
    let urlString: String

    var body: some View {
        if let url = URL(string: urlString) {
            AsyncImage(url: url) {
                $0
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                Circle().redacted(reason: .placeholder)
            }
            .frame(height: 100)
            .foregroundStyle(.gray.opacity(0.5))
        }
    }
}

#Preview {
    AsyncImageView(urlString: "https://markom.netlify.app/static/8aa696cf7b52831460283d61d54c0c1f/logo.png")
}
