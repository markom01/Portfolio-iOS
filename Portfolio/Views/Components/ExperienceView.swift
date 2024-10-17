//
//  ExperiencesView.swift
//  Portfolio
//
//  Created by Marko Meseldzija on 15.3.24..
//

import SwiftUI
@_spi(Advanced) import SwiftUIIntrospect

struct ExperienceView: View {
    let experience: Experience
    var isExpanded = false

    @Namespace var namespace

    var body: some View {
        if isExpanded {
            ListScreen {
                Section("About") { Text(experience.about) }
                Section("Tech Stack") {
                    DisclosureGroup {
                        SkillsView(technologies: AppleFrameworks.allCases, adjustEdgeInsets: true)
                    } label: {
                        Text("Apple Frameworks")
                    }
                    DisclosureGroup {
                        SkillsView(technologies: experience.technologies, adjustEdgeInsets: true)
                    } label: {
                        Text("Technologies")
                    }
                    DisclosureGroup {
                        SkillsView(technologies: Libraries.allCases, adjustEdgeInsets: true)
                    } label: {
                        Text("Libraries")
                    }
                }
                Section("Apps") {
                    ProjectsView(namespace: namespace, projects: experience.projects)
                        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                }
            }
            .navigationDestination(for: Project.self) {
                if #available(iOS 18, *) {
                    ProjectView(project: $0, isExpanded: true)
#if os(iOS)
                        .navigationTransition(.zoom(sourceID: $0.id, in: namespace))
#endif
                } else { ProjectView(project: $0, isExpanded: true) }
            }
            .background(.ultraThinMaterial)
            .toolbar {
                ToolbarItem(placement: Constants.titlePlacement) {
                    header
#if os(iOS)
                        .scaleEffect(0.8)
#endif
                }
#if os(macOS)
                ToolbarItem {
                    Spacer()
                }
#endif
                ToolbarItem {
                    if let urlString = experience.urlString, let url = URL(string: urlString) {
                        Link(destination: url) {
                            Label("Company Website", systemImage: "link")
                                .labelStyle(.titleAndIcon)
                        }
                    }
                }
            }
        } else { header }
    }

    var header: some View {
        HeaderView(
            isExpanded: false,
            headingView: .init(Text(experience.rawValue.capitalized)),
            subHeadingView: .init(subHeading(experience)),
            imageSource: experience.logo
        )
    }

    func subHeading(_ experience: Experience) -> some View {
        HStack(spacing: .xSmall) {
            Text(experience.start.formatted(.dateTime.month().year()))
            Text("-")
            if Calendar.current.isDateInToday(experience.end) {
                Text("Present")
            } else {
                Text(experience.end.formatted(.dateTime.month().year()))
            }
        }
    }
}

#Preview {
    ExperienceView(experience: Constants.experiences[0])
}
