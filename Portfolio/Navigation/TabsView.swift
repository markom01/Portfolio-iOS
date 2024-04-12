//
//  TabsView.swift
//  Portfolio
//
//  Created by Marko Meseldzija on 30.1.24..
//

import SwiftUI

struct TabsView: View {
    @Binding var appearance: ColorScheme
    @State var selectedTab = 0

    let tabs: [TabScreenView.Data] = [
        .init(
            navigation: .init(
                title: "Projects", tabIcon: "folder"
            ),
            content: .init(ProjectsView())
        ),
//        .init(
//            navigation: .init(
//                title: "Skills", tabIcon: "star"
//            ),
//            content: .init(
//                Text("Skills")
//            )
//        ),
//        .init(
//            navigation: .init(
//                title: "Experience", tabIcon: "suitcase"
//            ),
//            content: .init(
//               Text("Experience")
//            )
//        ),
        .init(
            navigation: .init(
                title: "About", tabIcon: "person"
            ),
            content: .init(AboutView())
        )
    ]

    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(Array(tabs.enumerated()), id: \.element.id) {
                TabScreenView(data: $1, appearance: $appearance).tag($0)
            }
        }
        .onChange(of: selectedTab) { print(selectedTab) }
#if os(macOS)
        .padding()
#endif
    }
}

#Preview {
    TabsView(appearance: .constant(.dark))
}
