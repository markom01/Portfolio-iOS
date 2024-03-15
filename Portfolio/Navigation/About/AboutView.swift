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
                image: .launchLogo,
                alignment: .center
            )
            ScrollStackView(delegate: directionDetector) {
                SectionView(header: "About") {
                    Text(Constants.placholderParagraph)
                }
                TechSectionView(technologies: [.swiftui, .uikit])
                SectionView(header: "Experience") {
                    ExperienceView(experience: Constants.experience)
                }
            }
        }
        .padding()
    }
}

#Preview {
    AboutView()
}
