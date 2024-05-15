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
        VStack(alignment: .leading, spacing: selectedId == project.id ? .large : .medium) {
            HeaderView(
                isExpanded: selectedId == project.id,
                headingView: .init(Text(project.name)),
                subHeadingView: .init(subheadingView),
                imageSource: .named(project.image),
                rightImage: "chevron.right"
            )
            projectButton
            description
            if selectedId == project.id {
                TechSectionView(title: "Technologies", technologies: project.technologies, isHeaderShown: selectedId == project.id)
                preview
            }
        }
        .padding(.vertical, selectedId == project.id ? .small : .xSmall)
        .contentShape(Rectangle())
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
    var description: SectionView<some View> {
        SectionView(
            header: "Description",
            isHeaderShown: selectedId == project.id
        ) {
            Text(project.description)
                .lineLimit(selectedId == project.id ? nil : 2)
        }
    }

    @ViewBuilder
    var preview: SectionView<VideoView>? {
        if let _ = URL(string: project.videoURLString) {
            SectionView(header: "Preview", isHeaderShown: selectedId == project.id) {
                VideoView(player: player)
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
