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
            TechSectionView(title: "Apple Frameworks", technologies: AppleFrameworks.allCases)
            TechSectionView(title: "Technologies", technologies: Tech.allCases)
            TechSectionView(title: "Libraries", technologies: Libraries.allCases)
        }
        SectionView(header: "Experience", isHeaderShown: selectedExperienceId == nil) {
            ExperiencesView(
                experiences: Constants.experiences,
                selectedExperienceId: $selectedExperienceId
            )
        }
        if selectedExperienceId == nil {
            HStack(alignment: .top) {
                SectionView(header: "Location") {
                    if let url = URL(string: "https://maps.apple.com/?address=Novi%20Sad,%20Serbia&auid=2172886330968018720&ll=45.260663,19.832161&lsp=6489&q=Novi%20Sad") {
                        Link(destination: url) {
                            Label("Novi Sad", systemImage: "mappin")
                        }
                    }
                }
                SectionView(header: "Languages") {
                    Label(
                        title: { Text("English | C1" )},
                        icon: { ImageView(source: .named(.uk), size: 30) }
                    )
                    Label(
                        title: { Text("Serbian | Native" )},
                        icon: { ImageView(source: .named(.srb), size: 30) }
                    )
                }
            }
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
