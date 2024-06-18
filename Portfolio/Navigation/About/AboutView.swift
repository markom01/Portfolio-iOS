//
//  AboutView.swift
//  Portfolio
//
//  Created by Marko Meseldzija on 10.3.24..
//

import SwiftUI
import SwiftUIIntrospect

struct AboutView: View {
    @Environment(\.colorScheme) var colorScheme
    @Namespace() var namespace

    var body: some View {
        VStack(spacing: .medium) {
            List { aboutSection }
                .navigationDestination(for: Experience.self) {
                    if #available(iOS 18.0, *) {
                        ExperienceView(experience: $0, isExpanded: true)
                            .navigationTransition(
                                .zoom(
                                    sourceID: $0.id,
                                    in: namespace
                                )
                            )
                    } else {
                        ExperienceView(experience: $0, isExpanded: true)
                    }
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
            Text(Constants.placholderParagraph).lineLimit(nil)
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
                    if #available(iOS 18.0, *) {
                        ExperienceView(experience: experience)
                            .matchedTransitionSource(id: experience.id, in: namespace)
                    } else {
                        ExperienceView(experience: experience)
                    }
                }
            }
        }
        Section("Location") {
            if let url = URL(string: "https://maps.apple.com/?address=Novi%20Sad,%20Serbia&auid=2172886330968018720&ll=45.260663,19.832161&lsp=6489&q=Novi%20Sad") {
                Link(destination: url) {
                    Label("Novi Sad, Serbia", systemImage: "mappin")
                }
                .contextMenu {
                    Button("Map") { print("click")}
                } preview: {
                    ImageView(source: .url("https://ychef.files.bbci.co.uk/1500x1000/p0btlr60.jpeg"), size: 300)
                        .overlay(alignment: .top) {
                            RoundedRectangle(cornerRadius: .xSmall)
                                .foregroundStyle(.white.opacity(0.5))
                                .padding(.small)
                                .frame(width: 180, height: 60)
                                .reverseMask {
                                    Text("Novi Sad")
                                        .font(.largeTitle)
                                        .bold()
                                        .padding(.small)
                                }
                        }
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
                    HStack {
                        let image = ImageView(source: .url("https://github.githubassets.com/favicons/favicon-dark.png"), size: 24)
                        Group {
                            if colorScheme == .light { image.colorInvert() } else { image }
                        }.padding(.horizontal, .xSmall)
                        Text("Project Repository")
                    }
                }
            }
        }

    }
}

#Preview {
    AboutView()
}

public extension View {
    @inlinable
    func reverseMask<Mask: View>(
        alignment: Alignment = .center,
        @ViewBuilder _ mask: () -> Mask
    ) -> some View {
        self.mask {
            Rectangle()
                .overlay(alignment: alignment) {
                    mask()
                        .blendMode(.destinationOut)
                }
        }
    }
}
