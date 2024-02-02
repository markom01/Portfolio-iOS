//
//  VideoView.swift
//  Portfolio
//
//  Created by Marko Meseldzija on 30.1.24..
//

import SwiftUI
import _AVKit_SwiftUI

struct VideoView: View {
    let url: URL
    let player = AVPlayer()
    
    var body: some View {
        VideoPlayer(player: player)
            .frame(height: 300)
            .onAppear {
                player.replaceCurrentItem(with: .init(url: url))
                player.isMuted = true
                player.play()
            }
    }
}


#Preview {
    VideoView(
        url: URL(
            string: "https://embed-ssl.wistia.com/deliveries/cc8402e8c16cc8f36d3f63bd29eb82f99f4b5f88/accudvh5jy.mp4"
        )!
    )
}
