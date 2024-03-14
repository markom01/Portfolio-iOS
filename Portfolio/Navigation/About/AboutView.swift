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
    let experience: Experience = .init(company: .hyperEther)

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
                    AsyncImageView(urlString: experience.company.imageURLString)
                }
            }
        }
        .padding()
    }

    struct Experience {
        let title: String = "iOS Developer"
        let company: Company
//        let start: Date
//        let end: Date
//        let projects: [Project]
//        let tech: [Tech]
    }
}

#Preview {
    AboutView()
}
