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
                TabScreenView(data: $1).tag($0)
            }
        }
#if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.visible, for: .navigationBar)
#elseif os(macOS)
        .padding()
#endif
        .toolbar {
            ToolbarItem(placement: .principal) {
                if selectedTab != tabs.count - 1 {
                    ImageView(source: .named(.launchLogo), size: .topBarLogo)
                }
            }
#if os(iOS)
         ToolbarItem(placement: .topBarTrailing) { navigationBarRightItem }
#endif
        }
    }
}

// MARK: Views
extension TabsView {
#if os(iOS)
    var navigationBarRightItem: some View {
        SwitchView(
            isOn: Binding(
                get: { appearance == .dark },
                set: { appearance = $0 ? .dark : .light }
            )
        )
    }
#endif
}

#Preview {
    TabsView(appearance: .constant(.dark))
}
