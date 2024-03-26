//
//  AboutView.swift
//  Portfolio
//
//  Created by Marko Meseldzija on 10.3.24..
//

import SwiftUI
import SwiftUIIntrospect

struct AboutView: View {
#if os(iOS)
    @ObservedObject var directionDetector = ScrollManager.DirectionDetector()
#endif

    var body: some View {
        VStack(spacing: .large) {
#if os(iOS)
            header
            ScrollStackView(spacing: .large, delegate: directionDetector) { aboutSection }
#elseif os(macOS)
            ScrollStackView(spacing: .large) {
                header
                aboutSection
            }
#endif
        }
        .padding()
    }

    var header: HeaderView {
        HeaderView(
            isExpanded: isExpanded,
            headingView: .init(Text("Marko Meseldžija")),
            subHeadingView: .init(Text("iOS Developer")),
            imageSource: .named(.launchLogo),
            alignment: .center
        )
    }

    @ViewBuilder
    var aboutSection: some View {
        SectionView(header: "About") {
            Text(Constants.placholderParagraph)
        }
        TechSectionView(technologies: Constants.technologies)
        SectionView(header: "Experience") {
            ExperiencesView(experiences: Constants.experiences)
        }
    }
}

extension AboutView {
    var isExpanded: Bool {
#if os(iOS)
        directionDetector.isScrolledUp
#elseif os(macOS)
        true
#endif
    }
}

#Preview {
    AboutView()
}
