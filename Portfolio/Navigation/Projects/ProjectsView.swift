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
            LazyVGrid(columns: Array(repeating: .init(spacing: .medium), count: 4)) {
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
                    .buttonStyle(PlainButtonStyle())
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
            Spacer()
        }
#if os(macOS)
        .removeListBg(image: projects.first(where: { $0.id == hoveredId })?.image)
            .toolbar {
                ToolbarItem(placement: Constants.titlePlacement) {
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

    func row(_ project: Project) -> some View {
        VStack {
            ImageView(source: .named(project.image), size: 60)
                .padding(.xSmall)
                .background(.background)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            Text(project.name).font(.caption).tint(.primary)
        }
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
    NavigationStack {
        ProjectsView()
    }
}
