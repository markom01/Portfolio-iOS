//
//  ProjectCardView.swift
//  Portfolio
//
//  Created by Marko Meseldzija on 30.1.24..
//

import SwiftUI
@_spi(Advanced) import SwiftUIIntrospect
import _AVKit_SwiftUI
import QuickLook

struct ProjectView: View {
    let project: Project

    @Environment(\.colorScheme) var colorScheme
    @State var url: URL?
    var images: [ProjectImagesTabView.Screenshot] {
        Array(1...10)
            .map { .init(image: "\(project.name)-\($0)") }
            .filter { $0.url != nil }
    }
    var isExpanded = false
    var skills: [Skill] {
        var skills = project.technologies
        let commonSkills: [Skill] = [AppleFrameworks.Swift, AppleFrameworks.SwiftUI, AppleFrameworks.UIKit, Tech.MVC, Tech.MVVM, Tech.GithubDesktop]
        skills.append(contentsOf: commonSkills)
        return skills
    }

    var body: some View {
        if isExpanded {
            ListScreen(bgImage: project.image) {
                description
                Section("Technologies") {
                    SkillsView(technologies: skills)
                }
                Section("Features") {
                    ForEach(project.features) { feature in
                        DisclosureGroup {
                            Text(feature.description).foregroundStyle(.secondary)
                        } label: {
                            Label(feature.name, systemImage: feature.icon)
                        }
                    }
                }
                ProjectImagesTabView(images: images, url: $url)
                preview
            }
            .toolbar {
                ToolbarItem(placement: Constants.titlePlacement) {
                    header
#if os(iOS)
                        .scaleEffect(0.8)
                        .frame(width: 200)
#endif
                }
#if os(macOS)
                ToolbarItem {
                    Spacer()
                }
#endif
                ToolbarItem {
                    projectButton
                }
            }
            .quickLookPreview($url, in: images.compactMap({ $0.url }))
        } else {
            header
        }
    }

    var header: some View {
        HeaderView(
            isExpanded: false,
            headingView: .init(Text(project.name)),
            subHeadingView: .init(subheadingView),
            imageSource: .named(project.image)
        )
    }
}

// MARK: Views
extension ProjectView {
    var subheadingView: some View {
        HStack(spacing: .xSmall) {
            Text(project.category.rawValue.capitalized)
            if isExpanded {
                Text("App")
            }
        }
    }

    @ViewBuilder
    var projectButton: some View {
        if let appStoreURL = URL(string: project.appStoreURLString) {
            Link("App Store", destination: appStoreURL)
        }
    }

    // MARK: Sections
    var description: some View {
        Section("Description") {
            Text(project.description).lineLimit(nil)
        }
    }

    @ViewBuilder
    var preview: some View {
        if let _ = URL(string: project.videoURLString) {
            Section("Preview") {
                VideoView(urlString: project.videoURLString)
                    .listRowInsets(EdgeInsets())
            }
        }
    }
}

#Preview {
    ProjectView(
        project: .init(
            name: "Project Name",
            category: .shopping,
            image: .gemJewel,
            description: Constants.placholderParagraph,
            features: [],
            technologies: Constants.technologies,
            appStoreURLString: "",
            videoURLString: ""
        ), isExpanded: true
    )
}
