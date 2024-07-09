//
//  TabsView.swift
//  Portfolio
//
//  Created by Marko Meseldzija on 30.1.24..
//

import SwiftUI

struct TabsView: View {
    let tabs: [TabScreenView.Data] = [
        .init(
            navigation: .init(
                title: "Projects", tabIcon: "folder"
            ),
            content: .init(ProjectsView())
        ),
        .init(
            navigation: .init(
                title: "About", tabIcon: "person"
            ),
            content: .init(AboutView())
        )
    ]
    @State private var selectedTab: TabScreenView.Data?

    var body: some View {
#if os(iOS)
        TabView {
            ForEach(Array(tabs.enumerated()), id: \.element.id) {
                TabScreenView(data: $1).tag($0)
            }
        }
#elseif os(macOS)
        NavigationSplitView {
            List(tabs) { tab in
                NavigationLink(destination: tab.content) {
                    Label(tab.navigation.title, systemImage: tab.navigation.tabIcon)
                }
            }
        } detail: {
            if let selectedTab {
                NavigationStack {
                    selectedTab.content
                }
            } else { Text("Select a tab") }
        }
        .padding()
        .onAppear { selectedTab = tabs.first }
#endif
    }
}

#Preview {
    TabsView()
}
