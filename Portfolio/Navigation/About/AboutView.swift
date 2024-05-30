//
//  AboutView.swift
//  Portfolio
//
//  Created by Marko Meseldzija on 10.3.24..
//

import SwiftUI
import SwiftUIIntrospect

struct AboutView: View {
    @Environment (\.colorScheme) var colorScheme
    
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
                        .padding(.horizontal, .xSmall)
                    Text("English")
                }
            }
            LabeledContent { Text("Native") } label: {
                HStack {
                    ImageView(source: .named(.srb), size: 30)
                        .padding(.horizontal, .xSmall)
                    Text("Serbian")
                }
            }
        }

        Section("Github") {
            if let url = URL(string: "https://github.com/markom01/Portfolio-iOS") {
                Link(destination: url) {
                    Label {
                        Text("Project Repository")
                    } icon: {
                        let image = ImageView(source: .url("https://github.githubassets.com/favicons/favicon-dark.png"), size: 24)
                        Group {
                            if colorScheme == .light {
                                image
                                    .colorInvert()
                            } else {
                                image
                            }
                        }.padding(.horizontal, .xSmall)
                    }
                }
            }
        }

    }
}

#Preview {
    AboutView()
}
