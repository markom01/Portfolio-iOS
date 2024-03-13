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
    let scrollPagerManager = ScrollManager.Pager()

    var body: some View {
        VStack(alignment: .leading, spacing: selectedId == project.id ? .large : .medium) {
            HeaderView(
                isExpanded: selectedId == project.id,
                headingView: .init(Text(project.name)),
                subHeadingView: .init(subheadingView),
                image: project.image,
                rightImage: "chevron.right"
            )
            projectButton
            description
            if selectedId == project.id {
                techStack
                preview
            }
        }
        .padding(.vertical, selectedId == project.id ? 10 : 5)
        .contentShape(Rectangle())
    }
}

// MARK: Views
extension ProjectCardView {
    @ViewBuilder
    var subheadingView: some View {
        if selectedId != project.id {
            Image(systemName: project.category.icon)
        }
        Text(project.category.rawValue.capitalized)
        if selectedId == project.id {
            Text("App")
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

    var techStack: SectionView<some View> {
        SectionView(
            header: "Tech Stack",
            isHeaderShown: selectedId == project.id
        ) {
            ScrollView(.horizontal) {
                HStack(spacing: .medium) {
                    ForEach(project.technologies) { tech in
                        VStack {
                            ImageView(source: .named(tech.image), size: 50)
                            Text(tech.rawValue).font(.callout)
                        }
                    }
                }
            }
            .introspect(.scrollView, on: .iOS(.v17)) { $0.delegate = scrollPagerManager }
            .scrollIndicators(.hidden)
            .scrollBounceBehavior(.basedOnSize)
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

extension ProjectCardView {
    struct Project: Identifiable {
        let name: String
        let category: Category
        let image: ImageResource
        let description: String
        let technologies: [Tech]
        let appStoreURLString: String
        let videoURLString: String
        let id = UUID()

        enum Category: String {
            case shopping

            var icon: String {
                switch self {
                case .shopping: "bag"
                }
            }
        }

        enum Tech: String, Identifiable {
            case swiftui = "SwiftUI"
            case uikit = "UIKit"

            var image: ImageResource {
                switch self {
                case .swiftui: return .gemJewel
                case .uikit: return .gemJewel
                }
            }

            var id: UUID { UUID() }
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
            technologies: [.swiftui, .uikit, .swiftui, .uikit, .swiftui, .uikit, .swiftui, .uikit, .swiftui, .uikit, .swiftui, .uikit, .swiftui, .uikit, .swiftui, .uikit],
            appStoreURLString: "",
            videoURLString: ""
        ),
        selectedId: nil,
        player: AVPlayer()
    )
}
