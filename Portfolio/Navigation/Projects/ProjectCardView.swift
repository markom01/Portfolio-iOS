//
//  ProjectCardView.swift
//  Portfolio
//
//  Created by Marko Meseldzija on 30.1.24..
//

import SwiftUI
import SwiftUIIntrospect
import _AVKit_SwiftUI

struct ProjectCardView: View {
    let project: Project
    var isExpanded = false

    var body: some View {
        if isExpanded {
            List {
                VStack {
                    header.padding(.bottom, .small)
                    projectButton
                }
                .listRowBackground(Color.clear)
                description
                Section("Technologies") {
                    SkillsView(technologies: project.technologies)
                }
                preview
            }
#if os(macOS)
        .removeListBg()
#endif
        } else {
            header
        }
    }

    var header: some View {
        HeaderView(
            isExpanded: isExpanded,
            headingView: .init(Text(project.name)),
            subHeadingView: .init(subheadingView),
            imageSource: .named(project.image)
        )
    }
}

// MARK: Views
extension ProjectCardView {
    var subheadingView: some View {
        HStack(spacing: .xSmall) {
            if !isExpanded {
                Image(systemName: project.category.icon)
            }
            Text(project.category.rawValue.capitalized)
            if isExpanded {
                Text("App")
            }
        }
    }

    @ViewBuilder
    var projectButton: some View {
        if let appStoreURL = URL(string: project.appStoreURLString) {
            HStack {
                Spacer()
                Link("App Store", destination: appStoreURL)
                    .buttonStyle(.borderedProminent)
                Spacer()
            }
        }
    }

    // MARK: Sections
    var description: some View {
        Section("Description") {
            Text(project.description)
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
    ProjectCardView(
        project: .init(
            name: "Project Name",
            category: .shopping,
            image: .gemJewel,
            description: Constants.placholderParagraph,
            technologies: Constants.technologies,
            appStoreURLString: "",
            videoURLString: ""
        )
    )
}
