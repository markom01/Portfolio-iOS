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
        VStack {
            if !shouldAnimate {
                Spacer()
            }
            ImageView(name: .gemJewel, size: shouldAnimate ? 30 : 100)
                .padding(.top, shouldAnimate ? 7.5 : 0)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                shouldAnimate = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    isVisible = false
                }
            }
        }
        .background(backgroundColor)
        .opacity(isVisible ? 1 : 0)
        .animation(.default, value: shouldAnimate)
        .animation(.default, value: isVisible)
    }
}

#Preview {
    LaunchView(backgroundColor: .black)
}
