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
        VStack(spacing: spacing) {
            header?.padding(.top)
            List { aboutSection }
#if os(iOS)
            .introspect(.list, on: .iOS(.v17)) { list in
                list.delegate = directionDetector
                list.bounces = false
            }
#endif
        }
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
            Section("About") {
                Text(Constants.placholderParagraph)
            }
            Section("Apple Frameworks") {
                SkillsView(technologies: AppleFrameworks.allCases)
            }
            Section("Technologies") {
                SkillsView(technologies: Tech.allCases)
            }
            Section("Libraries") {
                SkillsView(technologies: Libraries.allCases)
            }
        }
        Section("Experience") {
            ExperiencesView(
                experiences: Constants.experiences,
                selectedExperienceId: $selectedExperienceId
            )
        }
        if selectedExperienceId == nil {
            Section("Location") {
                if let url = URL(string: "https://maps.apple.com/?address=Novi%20Sad,%20Serbia&auid=2172886330968018720&ll=45.260663,19.832161&lsp=6489&q=Novi%20Sad") {
                    Link(destination: url) {
                        Label("Novi Sad, Serbia", systemImage: "mappin")
                    }
                }
            }
            Section("Languages") {
                LabeledContent { Text("C1") } label: {
                    HStack {
                        ImageView(source: .named(.uk), size: 30)
                        Text("English")
                    }
                }
                LabeledContent { Text("Native") } label: {
                    HStack {
                        ImageView(source: .named(.srb), size: 30)
                        Text("Serbian")
                    }
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

    var spacing: CGFloat {
#if os(iOS)
        directionDetector.isScrolledUp ? .large : .medium
#elseif os(macOS)
            .medium
#endif
    }
}

#Preview {
    AboutView()
}
