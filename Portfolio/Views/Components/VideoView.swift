//
//  VideoView.swift
//  Portfolio
//
//  Created by Marko Meseldzija on 30.1.24..
//

import SwiftUI
import _AVKit_SwiftUI

struct VideoView: View {
    let urlString: String
    var player: AVPlayer? {
        if let url = URL(string: urlString) { return .init(url: url) } else { return nil }
    }

    var body: some View {
        VideoPlayer(player: player)
            .frame(height: 300)
            .onAppear { player?.isMuted = true }
    }
}

#Preview {
    VideoView(
        urlString: "https://embed-ssl.wistia.com/deliveries/cc8402e8c16cc8f36d3f63bd29eb82f99f4b5f88/accudvh5jy.mp4"
    )
}
