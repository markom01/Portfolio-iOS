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

    var projects: [Project] = Constants.projects

    @Namespace var namespace

    var body: some View {
        VStack {
            LazyVGrid(columns: Array(repeating: .init(), count: 3)) {
                ForEach(projects) { project in
                    NavigationLink(value: project) {
                        if #available(iOS 18, *) {
                            row(project)
                                .contextMenu {
                                    NavigationLink(value: project) {
                                        Text("See Project")
                                    }
                                } preview: {
                                    ProjectCardView(project: project, isExpanded: true)
                                }
#if os(iOS)
                                .matchedTransitionSource(id: project.id, in: namespace)
#endif
                        } else { row(project) }
                    }
                }
            }
            .padding()
            .navigationDestination(for: Project.self) {
                if #available(iOS 18, *) {
                    ProjectCardView(project: $0, isExpanded: true)
#if os(iOS)
                        .navigationTransition(.zoom(sourceID: $0.id, in: namespace))
#endif
                } else { ProjectCardView(project: $0, isExpanded: true) }
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
            Spacer()
        }
    }

    func row(_ project: Project) -> some View {
        HeaderView(
            isExpanded: true,
            headingView: .init(EmptyView()),
            subHeadingView: .init(Text(project.name)),
            imageSource: .named(project.image)
        )
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

#Preview {
    ProjectsView()
}
