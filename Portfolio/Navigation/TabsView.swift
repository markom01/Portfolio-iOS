//
//  TabsView.swift
//  Portfolio
//
//  Created by Marko Meseldzija on 30.1.24..
//

import SwiftUI
import SwiftData

struct TabsView: View {
    @Environment(\.colorScheme) var colorScheme
    @Query var preferences: [Preference]
    @State var selectedTab = 0
    
    static let tabs: [TabScreenView.Data] = [
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
            content: .init(Text("B"))
        )
    ]
    
    var body: some View {
        if selectedTab == 0 {
            tabView.searchable(text: .constant(""), prompt: "Search Projects")
        } else { tabView }
    }
    
    var tabView: some View {
        TabView(selection: $selectedTab) {
            ForEach(Array(Self.tabs.enumerated()), id: \.element.id) { index, tab in
                TabScreenView(data: tab).tag(index)
            }
        }
#if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbar(ToolbarManager.shared.projectBar.visibility ?? .hidden, for: .bottomBar)
        .toolbarBackground(.visible, for: .bottomBar)
#elseif os(macOS)
        .padding()
#endif
        .toolbar {
            ToolbarItem(placement: .principal) { ImageView(source: .named(.launchLogo), size: .topBarLogo) }
            ToolbarItem(placement: ToolbarManager.shared.back.placement) { ToolbarManager.shared.back.view }
            ToolbarItem(placement: ToolbarManager.shared.projectBar.placement) { ToolbarManager.shared.projectBar.view }
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
                get: { preferences.first?.isDarkMode ?? (colorScheme == .dark) },
                set: {
                    preferences.first?.isDarkMode = $0
                    UIApplication.shared.setAlternateIconName(
                        preferences.first?.isDarkMode == true ? nil : "AppIconLight"
                    )
                }
            )
        )
    }
#endif
}

#Preview {
    TabsView()
}
