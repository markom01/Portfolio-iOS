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
        TabView {
            ForEach(Array(tabs.enumerated()), id: \.element.id) {
                TabScreenView(data: $1).tag($0)
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
