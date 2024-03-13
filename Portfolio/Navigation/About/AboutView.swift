//
//  AboutView.swift
//  Portfolio
//
//  Created by Marko Meseldzija on 10.3.24..
//

import SwiftUI
import SwiftUIIntrospect

struct AboutView: View {
    @ObservedObject var directionDetector = ScrollManager.DirectionDetector()

    var body: some View {
        VStack(spacing: .medium) {
            HeaderView(
                isExpanded: directionDetector.isScrolledUp,
                headingView: .init(Text("Marko Meseldžija")),
                subHeadingView: .init(Text("iOS Developer")),
                image: .launchLogo
            )
            ScrollView {
                ForEach(1...7, id: \.self) { _ in
                    SectionView(header: "About") {
                        Text(Constants.placholderParagraph)
                    }
                }
            }
            .introspect(.scrollView, on: .iOS(.v17)) {
                $0.delegate = directionDetector
                $0.bounces = false
            }
            .scrollIndicators(.hidden)
        }
        .padding()
    }
}

#Preview {
    AboutView()
}
