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
#if os(macOS)
    @State var isLogoVisible = false
#endif
    
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
            content: .init(Text("B"))
        ),
        .init(
            navigation: .init(
                title: "About", tabIcon: "person"
            ),
            content: .init(Text("B"))
        )
    ]
    
    var body: some View {
        NavigationStack {
             TabView {
                 ForEach(tabs) {
                     TabScreenView(data: $0).tag($0.id)
                 }
            }
#if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
#elseif os(macOS)
            .padding()
#endif
            .toolbar {
                ToolbarItem(placement: logoPlacement) { navigationBarTitleView }
#if os(iOS)
                ToolbarItem(placement: .topBarTrailing) { navigationBarRightItem }
#endif
            }
        }
        .background(.ultraThinMaterial)
        .onAppear {
            if preferences.isEmpty {
                context.insert(Preference(isDarkMode: colorScheme == .dark))
            }
#if os(macOS)
            setupWindow()
#endif
        }
        .overlay {
            LaunchView(
                backgroundColor: preferences.first?.isDarkMode ?? (colorScheme == .dark) ? .black : .white)
        }
#if os(iOS)
        .environment(\.colorScheme, preferences.first?.isDarkMode ?? (colorScheme == .dark) ? .dark : .light)
        .environment(\.openURL, OpenURLAction { url in
            openWebSheet(url)
            return .handled
        })
#endif
        .animation(.linear(duration: 0.3), value: preferences.first?.isDarkMode)
    }
}

// MARK: Views
extension TabsView {
    @ViewBuilder
    var navigationBarTitleView: some View {
#if os(macOS)
        if isLogoVisible {
            ImageView(source: .named(.launchLogo), size: .topBarLogo)
        } else { Spacer() }
#elseif os(iOS)
        ImageView(source: .named(.launchLogo), size: .topBarLogo)
#endif
    }
    
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

// MARK: Data
extension TabsView {
    var logoPlacement: ToolbarItemPlacement {
#if os(iOS)
        .principal
#elseif os(macOS)
        .status
#endif
    }
}

// MARK: Logic
extension TabsView {
#if os(iOS)
    func openWebSheet(_ url: URL) {
        if UIApplication.shared.canOpenURL(url) {
            let safariVC = SFSafariViewController(url: url)
            safariVC.modalPresentationStyle = .pageSheet
            safariVC.preferredBarTintColor = preferences.first?.isDarkMode ?? (colorScheme == .dark) ? .black : .white
            safariVC.preferredControlTintColor = .accent
            UIApplication.shared.keyWindow?.rootViewController?.present(safariVC, animated: true)
        }
    }
#endif
 
#if os(macOS)
    func setupWindow() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { isLogoVisible = true }
        guard let window = NSApplication.shared.windows.first else { return }
        window.isOpaque = false
        window.backgroundColor = .clear
        window.titlebarAppearsTransparent = true
    }
#endif
}

#Preview {
    TabsView()
        .modelContainer(for: Preference.self)
}
