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
            content: .init(Text("B"))
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
        .toolbarBackground(.visible, for: .bottomBar)
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
