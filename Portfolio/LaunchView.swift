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
            .overlay(alignment: shouldAnimate ? .top : .center) {
                ImageView(
                    source: .named(.launchLogo),
                    size: shouldAnimate ? .topBarLogo : 100
                )
#if os(iOS)
                .padding(.top, UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0 > 0 ? -5 : 0)
#elseif os(macOS)
                .padding(.top, shouldAnimate ? -42.5 : 0)
#endif
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
            .background(.ultraThinMaterial)
#endif
            .opacity(isVisible ? 1 : 0)
            .animation(.default, value: shouldAnimate)
            .animation(.default, value: isVisible)
    }
}

#Preview {
    LaunchView(backgroundColor: .black)
}
