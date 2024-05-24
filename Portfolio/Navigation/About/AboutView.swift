//
//  AboutView.swift
//  Portfolio
//
//  Created by Marko Meseldzija on 10.3.24..
//

import SwiftUI
import SwiftUIIntrospect

struct AboutView: View {
    var body: some View {
        VStack(spacing: .medium) {
            List { aboutSection }
                .navigationDestination(for: Experience.self) {
                    ExperienceView(experience: $0, isExpanded: true)
                }
                .scrollBounceBehavior(.basedOnSize)
#if os(macOS)
                .removeListBg()
#endif
        }
        .toolbar {
            ToolbarItem(placement: .principal) { header
                .scaleEffect(0.8)
                .frame(width: 200)
            }
        }
    }

    @ViewBuilder
    var header: HeaderView? {
        HeaderView(
            isExpanded: false,
            headingView: .init(Text("Marko Meseldžija")),
            subHeadingView: .init(Text("iOS Developer")),
            imageSource: .named(.launchLogo),
            alignment: .center
        )
    }

    @ViewBuilder
    var aboutSection: some View {
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
        Section("Experience") {
            ForEach(Constants.experiences) { experience in
                NavigationLink(value: experience) {
                    ExperienceView(experience: experience)
                }
            }
        }
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

#Preview {
    AboutView()
}
