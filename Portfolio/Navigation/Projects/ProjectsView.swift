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
    let namespace: Namespace.ID
    var animateToolbars = true
    var animationDelay: CGFloat = 1
    var projects: [Project] = Constants.projects

#if os(macOS)
    @State var hoveredId: UUID?
#endif
    @State var showLaunchScreen = true

    var body: some View {
        ScrollStackView {
            LazyVGrid(columns: Array(repeating: .init(spacing: .medium), count: 4)) {
                ForEach(projects) { project in
                    VStack {
                        NavigationLink(value: project) {
                            if #available(iOS 18, *) {
                                row(project)
                                    .contextMenu {
                                        NavigationLink(value: project) {
                                            Text("See Project")
                                        }
                                    } preview: {
                                        ProjectView(project: project, isExpanded: true)
                                    }
#if os(iOS)
                                    .matchedTransitionSource(id: project.id, in: namespace) { source in
                                        source
                                            .background(.clear)
                                            .clipShape(RoundedRectangle(cornerRadius: .small))
                                    }
#endif
                            } else { row(project) }
                        }
                        .buttonStyle(PlainButtonStyle())
                        Text(project.name.rawValue)
                            .lineLimit(1)
                            .font(.caption)
                            .tint(.primary)
                    }
                    .padding(.vertical, .small)
                }
            }
            .padding()
            Spacer()
        }
        .toolbarVisibility(showLaunchScreen && animateToolbars ? .hidden : .automatic, for: .tabBar)
        .animation(.default, value: showLaunchScreen)
        .onAppear {
            if animateToolbars {
                DispatchQueue.main.asyncAfter(deadline: .now() + animationDelay) {
                    showLaunchScreen = false
                }
            }
        }
#if os(macOS)
        .removeListBg(image: projects.first(where: { $0.id == hoveredId })?.image)
        .animation(.linear(duration: 0.75), value: hoveredId)
#endif
    }

    func row(_ project: Project) -> some View {
            ImageView(source: .named(project.image), size: 60)
                .clipShape(RoundedRectangle(cornerRadius: .small))
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
