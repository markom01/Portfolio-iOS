//
//  LaunchView.swift
//  Portfolio
//
//  Created by Marko Meseldzija on 4.2.24..
//

import SwiftUI

struct LaunchView: View {
    let backgroundColor: Color
    @State var shouldAnimate = false
    @State var isVisible = true

    var body: some View {
        VStack {}
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(alignment: .center) {
                ImageView(
                    source: .named(.launchLogo),
                    size: 100
                )
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    shouldAnimate = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        isVisible = false
                    }
                }
            }
#if os(iOS)
            .background(backgroundColor)
#elseif os(macOS)
            .background(.ultraThickMaterial)
            .background {
                if !shouldAnimate {
                    Image(.launchLogo)
                        .resizable()
                        .scaledToFit()
                }
            }
#endif
            .opacity(isVisible ? 1 : 0)
            .animation(.default, value: shouldAnimate)
            .animation(.default, value: isVisible)
    }
}

#Preview {
    LaunchView(backgroundColor: .black)
}
