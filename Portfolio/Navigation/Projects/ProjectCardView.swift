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
    let selectedId: UUID?
    let player: AVPlayer

    var body: some View {
        VStack {
            HeaderView(
                isExpanded: selectedId == project.id,
                headingView: .init(Text(project.name)),
                subHeadingView: .init(subheadingView),
                imageSource: .named(project.image),
                rightImage: "chevron.right"
            )
            projectButton
        }
        if selectedId == project.id {
            description
            Section("Technologies") {
                SkillsView(technologies: project.technologies)
            }
            preview
        }
    }
}

// MARK: Views
extension ProjectCardView {
    var subheadingView: some View {
        HStack(spacing: .xSmall) {
            if selectedId != project.id {
                Image(systemName: project.category.icon)
            }
            Text(project.category.rawValue.capitalized)
            if selectedId == project.id {
                Text("App")
            }
        }
    }

    @ViewBuilder
    var projectButton: some View {
        if let appStoreURL = URL(string: project.appStoreURLString), selectedId == project.id {
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
                .lineLimit(selectedId == project.id ? nil : 2)
        }
    }

    @ViewBuilder
    var preview: some View {
        if let _ = URL(string: project.videoURLString) {
            Section("Preview") {
                VideoView(player: player)
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
        ),
        selectedId: nil,
        player: AVPlayer()
    )
}
