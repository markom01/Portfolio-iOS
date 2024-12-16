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
    @State var showLaunchScreen = true
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
            GeometryReader { geometry in
                ListScreen(bgImage: project.image) {
                    if showLaunchScreen {
                        ZStack {
                            ImageView(source: .named(project.image), size: 100)
                                .clipShape(RoundedRectangle(cornerRadius: .small))
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: geometry.size.height)
                        .listRowBackground(Color.clear)
                    } else {
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
                }
                .ignoresSafeArea(edges: showLaunchScreen ? .all : [])
                .animation(.default, value: showLaunchScreen)
                .toolbarVisibility(showLaunchScreen ? .hidden : .visible, for: .navigationBar, .tabBar)
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
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        showLaunchScreen = false
                    }
                }
            }
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
        project: Constants.projects[7], isExpanded: false
    )
}
