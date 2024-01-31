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
    let videoPlayer = AVPlayer()
    
    var body: some View {
        if let url = URL(string: urlString) {
            VideoPlayer(player: videoPlayer)
                .frame(height: 300)
                .onAppear {
                    videoPlayer.replaceCurrentItem(with: .init(url: url))
                    videoPlayer.isMuted = true
                }
        }
    }
}

#Preview {
    VideoView(
        urlString: "https://embed-ssl.wistia.com/deliveries/cc8402e8c16cc8f36d3f63bd29eb82f99f4b5f88/accudvh5jy.mp4"
    )
}
