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
    @Binding var isVideoFullScreen: Bool
    let videoPlayer = AVPlayer()
    
    init(urlString: String, isVideoFullScreen: Binding<Bool>) {
        self.urlString = urlString
        self._isVideoFullScreen = isVideoFullScreen
        if let url = URL(string: urlString) {
            videoPlayer.replaceCurrentItem(with: .init(url: url))
            videoPlayer.isMuted = true
        }
    }
    
    var body: some View {
        VideoPlayer(player: videoPlayer)
            .ignoresSafeArea(.all)
        .frame(height: isVideoFullScreen ? UIScreen.main.bounds.height : 300)
        .toolbar(isVideoFullScreen ? .hidden : .automatic, for: .navigationBar)
    }
}

#Preview {
    VideoView(
        urlString: "https://embed-ssl.wistia.com/deliveries/cc8402e8c16cc8f36d3f63bd29eb82f99f4b5f88/accudvh5jy.mp4",
        isVideoFullScreen: .constant(false))
}
