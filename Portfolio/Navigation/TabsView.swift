//
//  TabsView.swift
//  Portfolio
//
//  Created by Marko Meseldzija on 30.1.24..
//

import SwiftUI
import SwiftData
import SafariServices

struct TabsView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.modelContext) var context
    @Query var preferences: [Preference]
    
    var body: some View {
        NavigationStack {
             TabView {
                 ForEach(tabs) { TabScreenView(data: $0).tag($0.id) }
            }
             .navigationBarTitleDisplayMode(.inline)
             .toolbarBackground(.visible, for: .navigationBar)
             .toolbar {
                 ToolbarItem(placement: .principal) { navigationBarTitleView }
                 ToolbarItem(placement: .topBarTrailing) { navigationBarRightItem }
             }
        }
        .onAppear {
            if preferences.isEmpty {
                context.insert(Preference(isDarkMode: colorScheme == .dark))
            }
        }
        .environment(\.colorScheme, preferences.first?.isDarkMode ?? (colorScheme == .dark) ? .dark : .light)
        .overlay {
            LaunchView(
                backgroundColor: preferences.first?.isDarkMode ?? (colorScheme == .dark) ? .black : .white)
        }
        .environment(\.openURL, OpenURLAction { url in
            openWebSheet(url)
            return .handled
        })
        .animation(.linear(duration: 0.3), value: preferences.first?.isDarkMode)
    }
}

// MARK: Views
extension TabsView {
    var navigationBarTitleView: some View {
        ImageView(source: .named(.launchLogo), size: .launchImage)
    }
    
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
}

// MARK: Logic
extension TabsView {
    func openWebSheet(_ url: URL) {
        if UIApplication.shared.canOpenURL(url) {
            let safariVC = SFSafariViewController(url: url)
            safariVC.modalPresentationStyle = .pageSheet
            safariVC.preferredBarTintColor = preferences.first?.isDarkMode ?? (colorScheme == .dark) ? .black : .white
            safariVC.preferredControlTintColor = .accent
            UIApplication.shared.keyWindow?.rootViewController?.present(safariVC, animated: true)
        }
    }
}

// MARK: Data
extension TabsView {
    var tabs: [TabScreenView.Data] {
        [
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
                content: .init(Text("B"))
            ),
            .init(
                navigation: .init(
                    title: "About", tabIcon: "person"
                ),
                content: .init(Text("B"))
            ),
            
        ]
    }
}

#Preview {
    TabsView()
        .modelContainer(for: Preference.self)
}
