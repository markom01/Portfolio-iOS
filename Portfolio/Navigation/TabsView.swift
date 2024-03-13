//
//  TabsView.swift
//  Portfolio
//
//  Created by Marko Meseldzija on 30.1.24..
//

import SwiftUI

struct TabsView: View {
    @Binding var appearance: ColorScheme

    let tabs: [TabScreenView.Data] = [
        .init(
            navigation: .init(
                title: "Projects", tabIcon: "folder"
            ),
            content: .init(ProjectsView())
        ),
        .init(
            navigation: .init(
                title: "Skills", tabIcon: "star"
            ),
            content: .init(
                List { Text("Skills") }
            )
        ),
        .init(
            navigation: .init(
                title: "About", tabIcon: "person"
            ),
            content: .init(AboutView())
        )
    ]

    var body: some View {
        TabView {
            ForEach(tabs) {
                TabScreenView(data: $0)
            }
        }
#if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.visible, for: .navigationBar)
#elseif os(macOS)
        .padding()
#endif
        .toolbar {
            ToolbarItem(placement: .principal) { ImageView(source: .named(.launchLogo), size: .topBarLogo) }
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
