//
//  ShareView.swift
//  Portfolio
//
//  Created by Marko Meseldzija on 6.2.24..
//

import SwiftUI

struct ShareView: View {
    let urlString: String
    let title: String

    var body: some View {
        if let appStoreURL = URL(string: urlString) {
            ShareLink(item: appStoreURL) {
                HStack {
                    Image(systemName: "square.and.arrow.up").foregroundStyle(.white)
                    Text(title)
                }
            }.buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    ShareView(urlString: "https://www.google.com", title: "Google")
}
