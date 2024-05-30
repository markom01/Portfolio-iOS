//
//  ProjectsView.swift
//  Portfolio
//
//  Created by Marko Meseldzija on 30.1.24..
//

import SwiftUI
import SwiftUIIntrospect
import _AVKit_SwiftUI

struct ProjectsView: View {
#if os(macOS)
    @State var hoveredId: UUID?
#endif

    let projects: [Project] = [
        .init(
            name: "Gem + Jewel",
            category: .shopping,
            image: .gemJewel,
            description: Constants.placholderParagraph,
            technologies: Constants.technologies,
            appStoreURLString: "https://apps.apple.com/us/app/gem-jewel/id6466446330",
            videoURLString: "https://embed-ssl.wistia.com/deliveries/cc8402e8c16cc8f36d3f63bd29eb82f99f4b5f88/accudvh5jy.mp4"
        ),
        .init(
            name: "Second App",
            category: .shopping,
            image: .launchLogo,
            description: Constants.placholderParagraph,
            technologies: Constants.technologies,
            appStoreURLString: "",
            videoURLString: ""
        )
    ]

    var body: some View {
        List {
            ForEach(projects) { project in
                NavigationLink(value: project) {
                    ProjectCardView(project: project)
                        .contentShape(Rectangle())
#if os(macOS)
                        .padding(.small)
                        .onHover { hoveredId = $0 ? project.id : nil }
                        .background {
                            Color.white
                                .opacity(hoveredId == project.id ? 0.05 : 0)
                                .clipShape(RoundedRectangle(cornerRadius: .small))
                        }
#endif
                }
            }
        }
        .navigationDestination(for: Project.self) {
            ProjectCardView(project: $0, isExpanded: true)
        }
        .scrollBounceBehavior(.basedOnSize)
#if os(macOS)
        .removeListBg()
        .background {
            if let hoveredImage = projects.first(where: { $0.id == hoveredId })?.image {
                Image(hoveredImage)
                    .resizable()
                    .opacity(0.75)
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                HeaderView(
                    isExpanded: false,
                    headingView: .init(Text("Marko Meseldžija")),
                    subHeadingView: .init(Text("iOS Developer")),
                    imageSource: .named(.launchLogo),
                    alignment: .center
                )
            }
        }
        .animation(.linear(duration: 0.75), value: hoveredId)
#endif
    }
}

#Preview {
    ProjectsView()
}
