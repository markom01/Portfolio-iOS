//
//  TabsView.swift
//  Portfolio
//
//  Created by Marko Meseldzija on 30.1.24..
//

import SwiftUI

struct TabsView: View {
    @Namespace var namespace

    var tabs: [TabScreenView.Data] {
        [
            .init(
                navigation: .init(
                    title: "Projects", tabIcon: "folder"
                ),
                content: .init(
                    ProjectsView(namespace: namespace)
                        .navigationDestination(for: Project.self) {
                            if #available(iOS 18, *) {
                                ProjectView(project: $0, isExpanded: true)
#if os(iOS)
                                    .navigationTransition(.zoom(sourceID: $0.id, in: namespace))
#endif
                            } else { ProjectView(project: $0, isExpanded: true) }
                        }
                )
            ),
            .init(
                navigation: .init(
                    title: "About", tabIcon: "person"
                ),
                content: .init(AboutView())
            )
        ]
    }
    @State private var selectedTab: TabScreenView.Data?

    var body: some View {
        TabView {
            ForEach(Array(tabs.enumerated()), id: \.element.id) { index, tab in
                Tab(tab.navigation.title, systemImage: tab.navigation.tabIcon) {
                    TabScreenView(data: tab).tag(index)
                }
            }
        }
#if os(macOS)
        .padding()
#endif
    }
}

#Preview {
    TabsView()
}
