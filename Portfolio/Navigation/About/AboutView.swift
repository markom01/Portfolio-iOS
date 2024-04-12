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
    @State var selectedExperienceId: UUID?

    var body: some View {
        VStack(spacing: .large) {
#if os(iOS)
            header
            ScrollStackView(spacing: .large, selectedId: selectedExperienceId, delegate: directionDetector) { aboutSection }
#elseif os(macOS)
            ScrollStackView(spacing: .large, selectedId: selectedExperienceId) {
                header
                aboutSection
            }
#endif
        }
        .padding()
        .animation(.smooth, value: selectedExperienceId)
        .backButton($selectedExperienceId)
    }

    @ViewBuilder
    var header: HeaderView? {
        if selectedExperienceId == nil {
            HeaderView(
                isExpanded: isExpanded,
                headingView: .init(Text("Marko Meseldžija")),
                subHeadingView: .init(Text("iOS Developer")),
                imageSource: .named(.launchLogo),
                alignment: .center
            )
        }
    }

    @ViewBuilder
    var aboutSection: some View {
        if selectedExperienceId == nil {
            SectionView(header: "About") {
                Text(Constants.placholderParagraph)
            }
            TechSectionView(title: "Tech Stack", technologies: Constants.technologies)
            TechSectionView(title: "Architechtures", technologies: Constants.architechtures)
        }
        SectionView(header: "Experience", isHeaderShown: selectedExperienceId == nil) {
            ExperiencesView(
                experiences: Constants.experiences,
                selectedExperienceId: $selectedExperienceId
            )
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
