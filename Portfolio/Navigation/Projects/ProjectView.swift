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
    var isExpanded = false
    var skills: [Skill] {
        var skills = project.technologies
        let commonSkills: [Skill] = [AppleFrameworks.Swift, AppleFrameworks.SwiftUI, AppleFrameworks.UIKit, AppleFrameworks.Combine, Tech.MVC, Tech.MVVM, Tech.UserDefaults, Tech.GithubDesktop, Tech.spm, Tech.pods, Libraries.AlamoFire]
        for element in commonSkills {
            if !skills.contains(where: { $0.rawValue == element.rawValue }) {
                skills.append(element)
            }
        }
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
                            Label {
                                Text(feature.name)
                            } icon: {
                                Image(systemName: feature.icon)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20)
                            }
                        }
                    }
                }
                ProjectImagesTabView(images: project.images, url: $url)
                preview
            }
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
                    projectButton
                }
            }
            .quickLookPreview($url, in: project.images.map { $0.url })
        } else {
            header
        }
    }

    var header: some View {
        HeaderView(
            isExpanded: false,
            headingView: .init(Text(project.name.rawValue)),
            subHeadingView: .init(subheadingView),
            imageSource: .named(project.image)
        )
    }
}

// MARK: Views
extension ProjectView {
    var subheadingView: some View {
        HStack(spacing: .xSmall) {
            Text(project.category.rawValue)
            if isExpanded && project.category != .SDK {
                Text("App")
            }
        }
    }

    @ViewBuilder
    var projectButton: some View {
        if let urlString = project.appStoreURLString, let appStoreURL = URL(string: urlString) {
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
            name: .JM,
            category: .Insurance,
            image: .gemJewel,
            description: .init(Constants.placholderParagraph),
            features: [],
            technologies: Constants.technologies,
            appStoreURLString: "",
            videoURLString: ""
        ), isExpanded: true
    )
}
