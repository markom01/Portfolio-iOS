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

    var body: some View {
        if isExpanded {
            ListScreen {
                Section("About") { Text(experience.about) }
                Section("Apple Frameworks") {
                    SkillsView(technologies: AppleFrameworks.allCases)
                }
                Section("Technologies") {
                    SkillsView(technologies: experience.technologies)
                }
                Section("Libraries") {
                    SkillsView(technologies: Libraries.allCases)
                }
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
